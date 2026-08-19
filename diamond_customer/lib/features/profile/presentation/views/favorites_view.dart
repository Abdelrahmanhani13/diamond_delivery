import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/vendor_card.dart';
import '../controller/favorites_cubit.dart';
import '../controller/favorites_state.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: context.tr('favorites')),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: context.primaryThemeColor,
              unselectedLabelColor: context.textSecondaryColor,
              indicatorColor: context.primaryThemeColor,
              tabs: [
                Tab(text: context.tr('stores')),
                Tab(text: context.tr('products')),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _FavoriteVendorsTab(),
                  _FavoriteProductsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteVendorsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesInitial ||
            (state is FavoriteVendorsLoading &&
                context.read<FavoritesCubit>().state is! FavoriteVendorsLoaded)) {
          return Center(
            child: CircularProgressIndicator(color: context.primaryThemeColor),
          );
        }

        if (state is FavoriteVendorsError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppColors.error),
            ),
          );
        }

        if (state is FavoriteVendorsLoaded) {
          final vendors = state.vendors;
          if (vendors.isEmpty) {
            return EmptyStateWidget(
              title: context.tr('noFavoriteStores'),
              icon: Icons.storefront_outlined,
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                context.read<FavoritesCubit>().fetchFavoriteVendors(refresh: true),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: vendors.length + (state.hasReachedMax ? 0 : 1),
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                if (index >= vendors.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final v = vendors[index];
                return VendorCard(
                  vendor: v,
                  onTap: () => context.push(
                    AppRoutes.productsList,
                    extra: {'vendorId': v.id, 'vendorName': v.name},
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _FavoriteProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesInitial ||
            (state is FavoriteProductsLoading &&
                context.read<FavoritesCubit>().state is! FavoriteProductsLoaded)) {
          return Center(
            child: CircularProgressIndicator(color: context.primaryThemeColor),
          );
        }

        if (state is FavoriteProductsError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppColors.error),
            ),
          );
        }

        if (state is FavoriteProductsLoaded) {
          final products = state.products;
          if (products.isEmpty) {
            return EmptyStateWidget(
              title: context.tr('noFavoriteProducts'),
              icon: Icons.fastfood_outlined,
            );
          }
          return RefreshIndicator(
            onRefresh: () => context
                .read<FavoritesCubit>()
                .fetchFavoriteProducts(refresh: true),
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: products.length + (state.hasReachedMax ? 0 : 1),
              itemBuilder: (context, index) {
                if (index >= products.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ProductCard(
                  product: products[index],
                  onTap: () => context.push(
                    AppRoutes.productDetails,
                    extra: products[index].id,
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
