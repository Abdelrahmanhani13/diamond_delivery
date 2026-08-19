import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/vendor_card.dart';
import '../controller/search_cubit.dart';
import '../controller/search_state.dart';
import '../widgets/recent_search_chip.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _controller = TextEditingController();
  final List<String> _recent = ['برجر', 'صيدلية', 'سوبرماركت'];
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isNotEmpty) {
      if (!_recent.contains(query.trim())) {
        setState(() {
          _recent.insert(0, query.trim());
          if (_recent.length > 10) _recent.removeLast();
        });
      }
      context.read<SearchCubit>().search(query.trim());
    } else {
      context.read<SearchCubit>().search('');
    }
  }

  void _onChanged(String val) {
    _debounce?.cancel();
    if (val.trim().isEmpty) {
      context.read<SearchCubit>().search('');
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _onSearch(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18.sp,
                      color: context.textPrimaryColor,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 46.h,
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                        color: context.greyLightColor,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: context.textSecondaryColor,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              autofocus: true,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: context.textPrimaryColor,
                              ),
                              decoration: InputDecoration(
                                hintText: context.tr('searchPlaceholder'),
                                hintStyle: AppTextStyles.bodyMedium.copyWith(
                                  color: context.textSecondaryColor,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onSubmitted: _onSearch,
                              onChanged: _onChanged,
                            ),
                          ),
                          if (_controller.text.isNotEmpty)
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 18.sp,
                                color: context.textSecondaryColor,
                              ),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                _debounce?.cancel();
                                _controller.clear();
                                context.read<SearchCubit>().search('');
                                setState(() {});
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('recentSearches'),
                            style: AppTextStyles.headingSmall.copyWith(
                              color: context.textPrimaryColor,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: _recent
                                .map(
                                  (term) => RecentSearchChip(
                                    label: term,
                                    onTap: () {
                                      _controller.text = term;
                                      _onSearch(term);
                                    },
                                    onRemove: () =>
                                        setState(() => _recent.remove(term)),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is SearchLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: context.primaryThemeColor,
                      ),
                    );
                  }

                  if (state is SearchError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    );
                  }

                  if (state is SearchLoaded) {
                    final vendors = state.searchData.vendors;
                    final products = state.searchData.products;

                    if (vendors.isEmpty && products.isEmpty) {
                      return EmptyStateWidget(
                        title: context.tr('noResults'),
                        message: context.tr('tryDifferentSearch'),
                        icon: Icons.search_off_rounded,
                      );
                    }

                    return ListView(
                      padding: EdgeInsets.all(16.w),
                      children: [
                        if (vendors.isNotEmpty) ...[
                          Text(
                            context.tr('stores'),
                            style: AppTextStyles.headingSmall.copyWith(
                              color: context.textPrimaryColor,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          ...vendors.map(
                            (v) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: VendorCard(
                                vendor: v,
                                onTap: () => context.push(
                                  AppRoutes.productsList,
                                  extra: {
                                    'vendorId': v.id,
                                    'vendorName': v.name,
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                        if (products.isNotEmpty) ...[
                          Text(
                            context.tr('products'),
                            style: AppTextStyles.headingSmall.copyWith(
                              color: context.textPrimaryColor,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 12.w,
                              mainAxisSpacing: 12.h,
                            ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return ProductCard(
                                product: products[index],
                                onTap: () => context.push(
                                  AppRoutes.productDetails,
                                  extra: products[index].id,
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
