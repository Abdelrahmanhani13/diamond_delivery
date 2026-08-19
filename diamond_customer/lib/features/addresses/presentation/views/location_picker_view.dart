import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../controller/location_picker_cubit/location_picker_cubit.dart';
import '../controller/location_picker_cubit/location_picker_state.dart';
import '../../domain/entities/coordinates_value_entity.dart';
import 'widgets/location_details_bottom_sheet.dart';

class LocationPickerView extends StatelessWidget {
  const LocationPickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocationPickerCubit>()..useCurrentLocation(),
      child: const _LocationPickerBody(),
    );
  }
}

class _LocationPickerBody extends StatefulWidget {
  const _LocationPickerBody();

  @override
  State<_LocationPickerBody> createState() => _LocationPickerBodyState();
}

class _LocationPickerBodyState extends State<_LocationPickerBody> {
  final _searchController = TextEditingController();
  final MapController _mapController = MapController();
  Timer? _dragDebounce;

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    _dragDebounce?.cancel();
    super.dispose();
  }

  void _onMapPositionChanged(MapCamera camera, bool hasGesture) {
    if (hasGesture) {
      _dragDebounce?.cancel();
      _dragDebounce = Timer(const Duration(milliseconds: 800), () {
        context.read<LocationPickerCubit>().updateSelectedPosition(
              Coordinates(
                latitude: camera.center.latitude,
                longitude: camera.center.longitude,
              ),
            );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: context.isArabic ? 'تحديد موقع التوصيل' : 'Select Delivery Location'),
      body: BlocConsumer<LocationPickerCubit, LocationPickerState>(
          listener: (context, state) {
            if (state is LocationPickerError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            LatLng mapCenter = const LatLng(24.7136, 46.6753); // Default Riyadh
            if (state is LocationPickerLoaded) {
              mapCenter = LatLng(
                state.coordinates.latitude,
                state.coordinates.longitude,
              );
            }

            return Column(
              children: [
                // Search Field
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: AppTextField(
                    controller: _searchController,
                    hint: 'ابحث عن حي، معلم، أو شارع...',
                    prefixIcon: Icons.search_rounded,
                    onChanged: (val) =>
                        context.read<LocationPickerCubit>().searchAddress(val),
                  ),
                ),

                // Map container
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              initialCenter: mapCenter,
                              initialZoom: 15.0,
                              onPositionChanged: _onMapPositionChanged,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName:
                                    'com.diamondvillage.customer',
                              ),
                            ],
                          ),

                          // Central Pin
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 40.h),
                              child: Icon(
                                Icons.location_on_rounded,
                                size: 46.sp,
                                color: AppColors.error,
                              ),
                            ),
                          ),

                          // Re-center floating button
                          Positioned(
                            bottom: 20.h,
                            right: 20.w,
                            child: FloatingActionButton.small(
                              heroTag: 'recenter_map',
                              backgroundColor: AppColors.surface,
                              elevation: 4,
                              onPressed: () {
                                context
                                    .read<LocationPickerCubit>()
                                    .useCurrentLocation();
                                if (state is LocationPickerLoaded) {
                                  _mapController.move(
                                    LatLng(
                                      state.coordinates.latitude,
                                      state.coordinates.longitude,
                                    ),
                                    15.0,
                                  );
                                }
                              },
                              child: Icon(
                                Icons.my_location_rounded,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                            ),
                          ),

                          if (state is LocationPickerLoaded && state.isSearching)
                            const Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: LinearProgressIndicator(),
                            ),

                          // Search Results dropdown
                          if (state is LocationPickerLoaded &&
                              state.searchResults.isNotEmpty)
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: AppColors.surface.withValues(alpha: 0.95),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.searchResults.length,
                                  itemBuilder: (context, i) {
                                    final res = state.searchResults[i];
                                    return ListTile(
                                      title: Text(
                                        res.displayName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () {
                                        context
                                            .read<LocationPickerCubit>()
                                            .selectSearchResult(res);
                                        _mapController.move(
                                          LatLng(res.latitude, res.longitude),
                                          15.0,
                                        );
                                        _searchController.clear();
                                      },
                                    );
                                  },
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom sheet card for picked location
                LocationDetailsBottomSheet(
                  state: state,
                  onConfirm: () {
                    if (state is LocationPickerLoaded) {
                      context.pop(state.address);
                    }
                  },
                ),
              ],
            );
          },
        ),
      );
  }
}
