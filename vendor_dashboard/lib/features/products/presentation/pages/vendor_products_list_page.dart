import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_dashboard/features/products/presentation/controller/vendor_products_cubit/vendor_products_cubit.dart';
import 'package:vendor_dashboard/features/products/presentation/controller/vendor_products_cubit/vendor_products_state.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';

import '../widgets/product_item_card.dart';

class VendorProductsListPage extends StatefulWidget {
  const VendorProductsListPage({super.key});

  @override
  State<VendorProductsListPage> createState() => _VendorProductsListPageState();
}

class _VendorProductsListPageState extends State<VendorProductsListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<VendorProductsCubit>().fetchProducts(refresh: true);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<VendorProductsCubit>().fetchProducts();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: VendorColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: VendorColors.surface,
          elevation: 0,
          title: Text(
            'منتجاتي',
            style: VendorTextStyles.headingLarge.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.refresh_rounded,
                color: VendorColors.textPrimary,
              ),
              onPressed: () {
                context.read<VendorProductsCubit>().fetchProducts(
                  refresh: true,
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await context.push(RoutePaths.productAddEdit);
            if (context.mounted) {
              context.read<VendorProductsCubit>().fetchProducts(refresh: true);
            }
          },
          backgroundColor: VendorColors.primary,
          icon: const Icon(Icons.add_rounded),
          label: Text('إضافة منتج', style: VendorTextStyles.buttonMedium),
        ),
        body: BlocBuilder<VendorProductsCubit, VendorProductsState>(
          builder: (context, state) {
            if (state is VendorProductsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: VendorColors.primary),
              );
            }

            if (state is VendorProductsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 56,
                        color: VendorColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'تعذر تحميل المنتجات',
                        style: VendorTextStyles.headingSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: VendorTextStyles.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: () {
                          context.read<VendorProductsCubit>().fetchProducts(
                            refresh: true,
                          );
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is VendorProductsLoaded) {
              if (state.products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 80,
                        color: VendorColors.grey.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد منتجات حالياً',
                        style: VendorTextStyles.headingSmall.copyWith(
                          color: VendorColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'أضف منتجك الأول من الزر أدناه',
                        style: VendorTextStyles.bodySmall,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<VendorProductsCubit>().fetchProducts(
                    refresh: true,
                  );
                },
                color: VendorColors.primary,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                  itemCount: state.hasReachedMax
                      ? state.products.length
                      : state.products.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.products.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(
                            color: VendorColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }

                    final product = state.products[index];
                    return ProductItemCard(
                      product: product,
                      onTap: () async {
                        await context.push(
                          RoutePaths.productAddEdit,
                          extra: product,
                        );
                        if (context.mounted) {
                          context.read<VendorProductsCubit>().fetchProducts(
                            refresh: true,
                          );
                        }
                      },
                      onDelete: () => _showDeleteDialog(context, product.id),
                      onAvailabilityChanged: (val) {
                        context.read<VendorProductsCubit>().changeAvailability(
                          product.id,
                          val,
                        );
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف المنتج'),
        content: const Text(
          'هل أنت متأكد من حذف هذا المنتج؟ لا يمكن التراجع عن هذا الإجراء.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<VendorProductsCubit>().deleteProduct(productId);
            },
            child: const Text(
              'حذف',
              style: TextStyle(color: VendorColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
