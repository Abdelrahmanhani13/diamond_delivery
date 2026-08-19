import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/vendor_card.dart';
import '../controller/vendor_list_cubit.dart';
import '../controller/vendor_list_state.dart';

class StoresListView extends StatefulWidget {
  const StoresListView({super.key, this.categoryTitle});

  final String? categoryTitle;

  @override
  State<StoresListView> createState() => _StoresListViewState();
}

class _StoresListViewState extends State<StoresListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<VendorListCubit>().fetchVendors();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.categoryTitle ?? context.tr('stores');

    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: title),
      body: BlocBuilder<VendorListCubit, VendorListState>(
        builder: (context, state) {
          if (state is VendorListInitial || (state is VendorListLoading && context.read<VendorListCubit>().state is! VendorListLoaded)) {
            return Center(child: CircularProgressIndicator(color: context.primaryThemeColor));
          }

          if (state is VendorListError && context.read<VendorListCubit>().state is! VendorListLoaded) {
            return Center(child: Text(state.message, style: const TextStyle(color: AppColors.error)));
          }

          if (state is VendorListLoaded) {
            final stores = state.vendors;
            
            if (stores.isEmpty) {
              return EmptyStateWidget(
                title: context.tr('noResults'),
                icon: Icons.storefront_outlined,
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<VendorListCubit>().fetchVendors(refresh: true),
              child: ListView.separated(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                itemCount: stores.length + (state.hasReachedMax ? 0 : 1),
                separatorBuilder: (_, _) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  if (index >= stores.length) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(color: context.primaryThemeColor),
                      ),
                    );
                  }
                  final s = stores[index];
                  return VendorCard(
                    vendor: s,
                    onTap: () {
                      context.push(AppRoutes.productsList, extra: {'vendorId': s.id, 'vendorName': s.name});
                    },
                  ).animate().fadeIn(delay: (index * 60).ms, duration: 300.ms).slideY(begin: 0.1, end: 0);
                },
              ),
            );
          }
          
          return const SizedBox();
        },
      ),
    );
  }
}
