import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../stores/presentation/controller/vendor_details_cubit.dart';
import '../../../stores/presentation/controller/vendor_details_state.dart';
import '../controller/product_list_cubit.dart';
import '../controller/product_list_state.dart';
import '../../domain/entities/product.dart';
import 'widgets/product_tile.dart';
import 'widgets/vendor_details_app_bar.dart';
import 'widgets/cart_bottom_bar.dart';

class ProductsListView extends StatefulWidget {
  const ProductsListView({
    super.key,
    this.vendorId,
    this.vendorName = 'المتجر',
  });

  final String? vendorId;
  final String vendorName;

  @override
  State<ProductsListView> createState() => _ProductsListViewState();
}

class _ProductsListViewState extends State<ProductsListView> {
  final Map<int, int> _cartQuantities = {};
  List<Product> _products = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context
          .read<ProductListCubit>()
          .fetchProducts(vendorId: widget.vendorId);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double _calculateTotal() {
    double total = 0;
    _cartQuantities.forEach((index, qty) {
      final p = _products[index];
      total += (p.discountPrice ?? p.price) * qty;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Vendor Details Header (if vendorId provided)
              _buildAppBar(context),

              // Menu title section
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المنتجات',
                        style: AppTextStyles.headingMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.filter_list_rounded,
                        color: AppColors.primary,
                        size: 22.sp,
                      ),
                    ],
                  ),
                ),
              ),

              // Product listing
              _buildProductList(),
            ],
          ),
        ),
        bottomNavigationBar: _cartQuantities.isNotEmpty
            ? CartBottomBar(
                totalItems:
                    _cartQuantities.values.reduce((a, b) => a + b),
                totalPrice: _calculateTotal(),
                onViewCart: () => context.push(AppRoutes.cart),
              )
            : null,
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    if (widget.vendorId != null) {
      return BlocBuilder<VendorDetailsCubit, VendorDetailsState>(
        builder: (context, state) {
          if (state is VendorDetailsLoaded) {
            return VendorDetailsAppBar(vendor: state.vendor);
          }
          return SliverAppBar(
            expandedHeight: 56.h,
            pinned: true,
            title: Text(widget.vendorName),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          );
        },
      );
    }

    return SliverAppBar(
      expandedHeight: 56.h,
      pinned: true,
      title: Text(widget.vendorName),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
    );
  }

  Widget _buildProductList() {
    return BlocBuilder<ProductListCubit, ProductListState>(
      builder: (context, state) {
        if (state is ProductListLoading &&
            context.read<ProductListCubit>().state is! ProductListLoaded) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state is ProductListError &&
            context.read<ProductListCubit>().state is! ProductListLoaded) {
          return SliverFillRemaining(
            child: Center(child: Text(state.message)),
          );
        }

        if (state is ProductListLoaded) {
          _products = state.products;
          if (_products.isEmpty) {
            return const SliverFillRemaining(
              child: Center(child: Text('لا توجد منتجات')),
            );
          }
          return SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= _products.length) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final product = _products[index];
                  final qty = _cartQuantities[index] ?? 0;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: ProductTile(
                      name: product.name,
                      price:
                          '${product.discountPrice ?? product.price} ر.س',
                      description: product.description,
                      imageUrl: product.imageUrls.isNotEmpty
                          ? product.imageUrls.first
                          : null,
                      quantityInCart: qty,
                      onAdd: () {
                        setState(() => _cartQuantities[index] = 1);
                      },
                      onIncrement: () {
                        setState(() => _cartQuantities[index] = qty + 1);
                      },
                      onDecrement: () {
                        setState(() {
                          if (qty > 1) {
                            _cartQuantities[index] = qty - 1;
                          } else {
                            _cartQuantities.remove(index);
                          }
                        });
                      },
                      onTap: () => context.push(
                        AppRoutes.productDetails,
                        extra: product.id,
                      ),
                    )
                        .animate()
                        .fadeIn(
                          delay: (index * 40).ms,
                          duration: 250.ms,
                        )
                        .slideY(begin: 0.05, end: 0),
                  );
                },
                childCount:
                    _products.length + (state.hasReachedMax ? 0 : 1),
              ),
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox());
      },
    );
  }
}
