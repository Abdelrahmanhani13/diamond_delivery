import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:vendor_dashboard/core/constants/app_radius.dart';
import 'package:vendor_dashboard/core/di/service_locator.dart';
import 'package:vendor_dashboard/core/theme/app_colors.dart';
import 'package:vendor_dashboard/core/theme/app_text_styles.dart';
import 'package:vendor_dashboard/core/widgets/app_button.dart';
import 'package:vendor_dashboard/core/widgets/app_text_field.dart';
import 'package:vendor_dashboard/core/widgets/custom_app_bar.dart';

import '../controller/location_picker_cubit/location_picker_cubit.dart';
import '../controller/location_picker_cubit/location_picker_state.dart';
import '../../domain/entities/coordinates_value_entity.dart';

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: const CustomAppBar(title: 'تحديد موقع التوصيل'),
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
                                    'com.diamondvillage.vendor',
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

                          if (state is LocationPickerLoaded &&
                              state.isSearching)
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: const LinearProgressIndicator(),
                            ),

                          // Search Results dropdown
                          if (state is LocationPickerLoaded &&
                              state.searchResults.isNotEmpty)
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: AppColors.surface.withValues(
                                  alpha: 0.95,
                                ),
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
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom sheet card for picked location
                Container(
                  margin: EdgeInsets.only(top: 16.h),
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: _buildBottomDetails(state),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomDetails(LocationPickerState state) {
    if (state is LocationPickerLoading || state is LocationPickerInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is LocationPickerLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.address.street.isNotEmpty
                          ? state.address.street
                          : state.address.displayName,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(2.h),
                    Text(
                      '${state.address.city}, ${state.address.country}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(20.h),
          AppButton(
            label: 'تأكيد هذا العنوان',
            icon: Icons.check_circle_outline_rounded,
            onPressed: () {
              // Return the chosen GeocodedAddress to the previous screen
              context.pop(state.address);
            },
          ),
        ],
      );
    }

    return const Center(child: Text('عذراً، حدث خطأ أثناء تحديد الموقع'));
  }
}
