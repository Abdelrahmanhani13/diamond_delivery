import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
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
    this.vendorName = '',
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
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildAppBar(context),

            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('products'),
                      style: AppTextStyles.headingMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            BlocBuilder<ProductListCubit, ProductListState>(
              builder: (context, state) {
                if (state is ProductListInitial ||
                    (state is ProductListLoading &&
                        context.read<ProductListCubit>().state
                            is! ProductListLoaded)) {
                  return SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: context.primaryThemeColor,
                      ),
                    ),
                  );
                }

                if (state is ProductListError &&
                    context.read<ProductListCubit>().state
                        is! ProductListLoaded) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                  );
                }

                if (state is ProductListLoaded) {
                  _products = state.products;

                  if (_products.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          context.tr('noResults'),
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: context.textSecondaryColor,
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= _products.length) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: context.primaryThemeColor,
                                ),
                              ),
                            );
                          }

                          final product = _products[index];
                          final qty = _cartQuantities[index] ?? 0;

                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: ProductTile(
                              product: product,
                              quantity: qty,
                              onTap: () => context.push(
                                AppRoutes.productDetails,
                                extra: product.id,
                              ),
                              onIncrement: () {
                                setState(() {
                                  _cartQuantities[index] = qty + 1;
                                });
                              },
                              onDecrement: () {
                                if (qty > 0) {
                                  setState(() {
                                    if (qty == 1) {
                                      _cartQuantities.remove(index);
                                    } else {
                                      _cartQuantities[index] = qty - 1;
                                    }
                                  });
                                }
                              },
                            ).animate().fadeIn(
                                  delay: (index * 50).ms,
                                  duration: 300.ms,
                                ),
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: _cartQuantities.isNotEmpty
          ? CartBottomBar(
              totalItems:
                  _cartQuantities.values.fold(0, (sum, q) => sum + q),
              totalPrice: _calculateTotal(),
              onViewCart: () => context.push(AppRoutes.cart),
            )
          : null,
    );
  }

  Widget _buildAppBar(BuildContext context) {
    if (widget.vendorId == null) {
      return SliverAppBar(
        floating: true,
        snap: true,
        title: Text(
          widget.vendorName.isNotEmpty ? widget.vendorName : context.tr('stores'),
        ),
      );
    }

    return BlocBuilder<VendorDetailsCubit, VendorDetailsState>(
      builder: (context, state) {
        if (state is VendorDetailsLoaded) {
          return VendorDetailsAppBar(vendor: state.vendor);
        }
        return SliverAppBar(
          floating: true,
          snap: true,
          title: Text(
            widget.vendorName.isNotEmpty ? widget.vendorName : context.tr('stores'),
          ),
        );
      },
    );
  }
}
