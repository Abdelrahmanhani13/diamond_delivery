import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../data/models/order_model.dart';
import '../controller/order_details_cubit.dart';
import '../controller/order_details_state.dart';
import '../widgets/info_card.dart';
import '../widgets/order_items_card.dart';
import '../widgets/order_status_timeline.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context) {
    // If orderId was passed in GoRouter extra or directly
    final id = orderId ?? (GoRouterState.of(context).extra as String?);

    if (id == null || id.isEmpty) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'تفاصيل الطلب'),
        body: const Center(child: Text('معرف الطلب غير صحيح')),
      );
    }

    return BlocProvider(
      create: (context) => getIt<OrderDetailsCubit>()..fetchOrderDetails(id),
      child: const _OrderDetailsViewBody(),
    );
  }
}

class _OrderDetailsViewBody extends StatelessWidget {
  const _OrderDetailsViewBody();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
        listener: (context, state) {
          if (state is OrderDetailsLoaded && state.message != null && state.message!.isNotEmpty) {
            AppToast.info(context, message: state.message!);
          } else if (state is OrderDetailsError) {
            AppToast.error(context, message: state.message);
          }
        },
        builder: (context, state) {
          final cubit = context.read<OrderDetailsCubit>();

          if (state is OrderDetailsLoading) {
            return Scaffold(
              backgroundColor: AppColors.scaffoldBackground,
              appBar: const CustomAppBar(title: 'تفاصيل الطلب'),
              body: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }

          if (state is OrderDetailsError && state is! OrderDetailsLoaded) {
            return Scaffold(
              backgroundColor: AppColors.scaffoldBackground,
              appBar: const CustomAppBar(title: 'تفاصيل الطلب'),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, size: 50.sp, color: AppColors.error),
                    Gap(12.h),
                    Text(state.message, style: AppTextStyles.bodyLarge),
                    Gap(16.h),
                    ElevatedButton(
                      onPressed: () {
                        final id = GoRouterState.of(context).extra as String?;
                        if (id != null) cubit.fetchOrderDetails(id);
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is OrderDetailsLoaded || state is OrderCancelling) {
            final order = (state is OrderDetailsLoaded)
                ? state.order
                : (state as dynamic).order as OrderModel?;

            if (order == null) return const SizedBox();

            final vendorName = order.vendorNameArabic?.isNotEmpty == true
                ? order.vendorNameArabic!
                : (order.vendorNameEnglish ?? 'المتجر');
            final createdDateStr = order.createdAt != null
                ? DateFormat('yyyy/MM/dd • hh:mm a').format(order.createdAt!)
                : '';
            final statusEnum = order.orderStatus.toOrderStatus;
            final canCancel = statusEnum == BackendOrderStatus.pending ||
                statusEnum == BackendOrderStatus.accepted;

            return Scaffold(
              backgroundColor: AppColors.scaffoldBackground,
              appBar: CustomAppBar(title: 'تفاصيل الطلب #${order.orderNumber}'),
              body: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                children: [
                  // Status & Timeline Banner Card
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'رقم الطلب: ${order.orderNumber}',
                              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text(createdDateStr, style: AppTextStyles.caption),
                          ],
                        ),
                        Gap(16.h),
                        OrderStatusTimeline(orderStatus: order.orderStatus),
                      ],
                    ),
                  ).animate().fadeIn(duration: 350.ms).slideY(begin: -0.05, end: 0),

                  Gap(14.h),

                  // Cancellation / Rejection Reasons if returned
                  if (order.cancellationReason != null && order.cancellationReason!.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'سبب الإلغاء:',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
                          ),
                          Gap(4.h),
                          Text(
                            order.cancellationReason!,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    Gap(14.h),
                  ],

                  if (order.rejectionReason != null && order.rejectionReason!.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'سبب الرفض:',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
                          ),
                          Gap(4.h),
                          Text(
                            order.rejectionReason!,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    Gap(14.h),
                  ],

                  // Store information card
                  InfoCard(
                    title: 'بيانات المتجر',
                    icon: Icons.storefront_outlined,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: order.vendorLogoUrl != null && order.vendorLogoUrl!.isNotEmpty
                                ? Image.network(
                                    order.vendorLogoUrl!,
                                    width: 48.w,
                                    height: 48.w,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.storefront_rounded),
                                  )
                                : Container(
                                    width: 48.w,
                                    height: 48.w,
                                    color: AppColors.greyLight,
                                    child: const Icon(Icons.storefront_rounded, color: AppColors.primary),
                                  ),
                          ),
                          Gap(14.w),
                          Text(
                            vendorName,
                            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ).animate().fadeIn(delay: 100.ms, duration: 350.ms),

                  Gap(14.h),

                  // Order snapshot items list
                  OrderItemsCard(
                    items: order.items,
                    subtotal: order.subtotal,
                    deliveryFee: order.deliveryFee,
                    total: order.total,
                  ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

                  Gap(14.h),

                  // Payment method card
                  if (order.paymentMethod != null && order.paymentMethod!.isNotEmpty)
                    InfoCard(
                      title: 'طريقة الدفع',
                      icon: Icons.payment_outlined,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.money_rounded, color: AppColors.primary, size: 20.sp),
                            Gap(10.w),
                            Text(
                              order.paymentMethod!,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                  Gap(14.h),

                  // Address info card
                  if (order.address != null)
                    InfoCard(
                      title: 'عنوان التوصيل',
                      icon: Icons.location_on_outlined,
                      children: [
                        Text(
                          order.address!.fullAddressText,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (order.address!.notes != null && order.address!.notes!.isNotEmpty) ...[
                          Gap(4.h),
                          Text(
                            'ملاحظات العنوان: ${order.address!.notes!}',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ],
                    ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

                  if (order.customerNotes != null && order.customerNotes!.isNotEmpty) ...[
                    Gap(14.h),
                    InfoCard(
                      title: 'ملاحظات العملاء',
                      icon: Icons.note_alt_outlined,
                      children: [
                        Text(
                          order.customerNotes!,
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ],

                  Gap(24.h),

                  // Cancel order action if cancellable
                  if (canCancel)
                    AppButton(
                      label: 'إلغاء الطلب',
                      variant: AppButtonVariant.outline,
                      icon: Icons.cancel_outlined,
                      isLoading: state is OrderCancelling,
                      onPressed: () => _showCancelDialog(context, cubit, order.id),
                    ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _showCancelDialog(
    BuildContext context,
    OrderDetailsCubit cubit,
    String orderId,
  ) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('إلغاء الطلب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('يرجى كتابة سبب الإلغاء:'),
            SizedBox(height: 10.h),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'مثال: التأخر في التجهيز / تغيير العنوان',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              final reason = reasonController.text.trim();
              if (reason.isEmpty) {
                AppToast.warning(context, message: 'يرجى إدخال سبب الإلغاء');
                return;
              }
              Navigator.pop(dialogContext);
              cubit.cancelOrder(orderId, reason);
            },
            child: const Text('تأكيد الإلغاء'),
          ),
        ],
      ),
    );
  }
}
