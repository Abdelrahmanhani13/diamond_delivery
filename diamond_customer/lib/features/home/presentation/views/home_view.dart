import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/vendor_card.dart';
import '../../../../core/widgets/product_card.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/promo_banner_slider.dart';
import '../widgets/category_grid_item.dart';
import '../widgets/feature_promo_card.dart';
import '../controller/home_cubit.dart';
import '../controller/home_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeInitial || state is HomeLoading) {
              return Center(
                child: CircularProgressIndicator(color: context.primaryThemeColor),
              );
            }

            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.error,
                    ),
                    SizedBox(height: 16.h),
                    Text(state.message),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<HomeCubit>().fetchHomeData(),
                      child: Text(context.tr('retry')),
                    ),
                  ],
                ),
              );
            }

            if (state is HomeLoaded) {
              final data = state.homeData;
              return RefreshIndicator(
                onRefresh: () => context.read<HomeCubit>().fetchHomeData(),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Expanded(
                              child: HomeSearchBar(
                                onTap: () => context.push(AppRoutes.search),
                              ),
                            ),
                            Gap(8.w),
                            Container(
                              decoration: BoxDecoration(
                                color: context.greyLightColor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.notifications_none_rounded,
                                  color: context.textPrimaryColor,
                                  size: 22.sp,
                                ),
                                onPressed: () =>
                                    context.push(AppRoutes.notifications),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (data.banners.isNotEmpty)
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                        sliver: SliverToBoxAdapter(
                          child: PromoBannerSlider(
                            banners: data.banners
                                .map(
                                  (b) => PromoBannerData(
                                    tag: b.tag ?? '',
                                    title: b.title,
                                    ctaLabel: b.ctaLabel ?? '',
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),

                    if (data.categories.isNotEmpty)
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
                        sliver: SliverToBoxAdapter(
                          child: SectionHeader(
                            title: context.tr('categories'),
                            actionLabel: context.tr('viewAll'),
                            onAction: () =>
                                context.push(AppRoutes.categories),
                          ),
                        ),
                      ),
                    if (data.categories.isNotEmpty)
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 14.h,
                            crossAxisSpacing: 8.w,
                            childAspectRatio: 0.78,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => CategoryGridItem(
                              category: data.categories[index],
                              onTap: () => context.push(AppRoutes.storesList),
                            ),
                            childCount: data.categories.length,
                          ),
                        ),
                      ),

                    if (data.featuredVendors.isNotEmpty)
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
                        sliver: SliverToBoxAdapter(
                          child: SectionHeader(
                            title: context.tr('featuredStores'),
                            actionLabel: context.tr('viewAll'),
                            onAction: () =>
                                context.push(AppRoutes.storesList),
                          ),
                        ),
                      ),
                    if (data.featuredVendors.isNotEmpty)
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: VendorCard(
                                vendor: data.featuredVendors[index],
                                onTap: () {},
                              ),
                            ),
                            childCount: data.featuredVendors.length,
                          ),
                        ),
                      ),

                    if (data.featuredProducts.isNotEmpty)
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
                        sliver: SliverToBoxAdapter(
                          child: SectionHeader(
                            title: context.tr('mostOrdered'),
                            actionLabel: context.tr('viewAll'),
                            onAction: () =>
                                context.push(AppRoutes.productsList),
                          ),
                        ),
                      ),
                    if (data.featuredProducts.isNotEmpty)
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                        sliver: SliverToBoxAdapter(
                          child: SizedBox(
                            height: 220.h,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.featuredProducts.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 12.w),
                              itemBuilder: (context, index) => ProductCard(
                                product: data.featuredProducts[index],
                                onTap: () => context.push(
                                  AppRoutes.productDetails,
                                  extra: data.featuredProducts[index].id,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
                      sliver: SliverToBoxAdapter(
                        child: FeaturePromoCard(
                          title: 'صيدليات الآن',
                          subtitle: 'توصيل خلال 30 دقيقة',
                          icon: Icons.medication_rounded,
                          ctaLabel: 'اكتشف',
                          onTap: () => context.push(AppRoutes.storesList),
                          image: 'assets/images/pexels-cottonbro-6865182.jpg',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.profile);
              break;
            case 1:
              context.go(AppRoutes.orders);
              break;
            case 2:
              context.push(AppRoutes.search);
              break;
            case 3:
              context.go(AppRoutes.home);
              break;
          }
        },
      ),
    );
  }
}
