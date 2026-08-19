import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../controller/cart_cubit.dart';
import '../controller/cart_state.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/order_summary_widget.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CartCubit>()..fetchCart(),
      child: const _CartViewBody(),
    );
  }
}

class _CartViewBody extends StatelessWidget {
  const _CartViewBody();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartLoaded && state.message != null && state.message!.isNotEmpty) {
            AppToast.error(context, message: state.message!);
          } else if (state is CartError) {
            AppToast.error(context, message: state.message);
          }
        },
        builder: (context, state) {
          final cartCubit = context.read<CartCubit>();

          if (state is CartLoading) {
            return Scaffold(
              backgroundColor: AppColors.scaffoldBackground,
              appBar: const CustomAppBar(title: 'سلة التسوق'),
              body: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }

          if (state is CartError && state is! CartLoaded) {
            return Scaffold(
              backgroundColor: AppColors.scaffoldBackground,
              appBar: const CustomAppBar(title: 'سلة التسوق'),
              body: EmptyStateWidget(
                title: 'حدث خطأ أثناء تحميل السلة',
                message: state.message,
                icon: Icons.error_outline_rounded,
              ),
            );
          }

          if (state is CartLoaded) {
            final cart = state.cart;
            final items = cart.items;

            if (items.isEmpty) {
              return Scaffold(
                backgroundColor: AppColors.scaffoldBackground,
                appBar: const CustomAppBar(title: 'سلة التسوق'),
                body: const EmptyStateWidget(
                  title: 'سلة المشتريات فارغة',
                  message: 'تصفح المتاجر والمنتجات وأضف ما ترغب لتظهر هنا',
                  icon: Icons.shopping_basket_outlined,
                ),
              );
            }

            return Scaffold(
              backgroundColor: AppColors.scaffoldBackground,
              appBar: CustomAppBar(
                title: 'سلة التسوق',
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete_sweep_rounded, color: AppColors.error),
                    tooltip: 'تفريغ السلة',
                    onPressed: () => _confirmClearCart(context, cartCubit),
                  ),
                ],
              ),
              body: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                children: [
                  // Vendor Header Info Card
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.primaryLight),
                    ),
                    child: Row(
                      children: [
                        if (cart.vendorLogoUrl != null && cart.vendorLogoUrl!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              cart.vendorLogoUrl!,
                              width: 40.w,
                              height: 40.w,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.store_rounded),
                            ),
                          )
                        else
                          Icon(Icons.store_rounded, color: AppColors.primary, size: 30.sp),
                        Gap(12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cart.vendorNameArabic.isNotEmpty
                                    ? cart.vendorNameArabic
                                    : cart.vendorNameEnglish,
                                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                              ),
                              if (cart.vendorMinimumOrder > 0)
                                Text(
                                  'الحد الأدنى للطلب: ${cart.vendorMinimumOrder.toStringAsFixed(0)} ر.س',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms),

                  Gap(16.h),

                  // Cart Items
                  ...List.generate(items.length, (index) {
                    final item = items[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: CartItemWidget(
                        item: item,
                        onIncrement: () {
                          cartCubit.updateItemQuantity(item.productId, item.quantity + 1);
                        },
                        onDecrement: () {
                          if (item.quantity > 1) {
                            cartCubit.updateItemQuantity(item.productId, item.quantity - 1);
                          } else {
                            cartCubit.removeItem(item.productId);
                          }
                        },
                        onRemove: () => cartCubit.removeItem(item.productId),
                      ).animate().fadeIn(delay: (index * 40).ms, duration: 300.ms),
                    );
                  }),

                  Gap(8.h),

                  // Order Summary Breakdown
                  OrderSummaryWidget(
                    subtotal: cart.subtotal,
                    deliveryFee: cart.deliveryFee,
                    total: cart.total,
                  ).animate().fadeIn(delay: 150.ms, duration: 350.ms),
                ],
              ),
              bottomNavigationBar: SafeArea(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: AppButton(
                    label: 'إتمام الطلب • ${cart.total.toStringAsFixed(0)} ر.س',
                    icon: Icons.payment_outlined,
                    onPressed: () => context.push(AppRoutes.checkout),
                  ),
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _confirmClearCart(BuildContext context, CartCubit cartCubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تفريغ السلة'),
        content: const Text('هل أنت تأكد من رغبتك في حذف جميع المنتجات من السلة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(dialogContext);
              cartCubit.clearCart();
            },
            child: const Text('تأكيد التفريغ'),
          ),
        ],
      ),
    );
  }
}
