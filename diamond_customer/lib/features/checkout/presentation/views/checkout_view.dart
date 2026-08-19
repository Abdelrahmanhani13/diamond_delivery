import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../addresses/domain/entities/address_domain_entity.dart';
import '../../../cart/presentation/widgets/order_summary_widget.dart';
import '../controller/checkout_cubit.dart';
import '../controller/checkout_state.dart';
import '../widgets/checkout_section_card.dart';
import '../widgets/payment_method_tile.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CheckoutCubit>()..loadCheckout(),
      child: const _CheckoutViewBody(),
    );
  }
}

class _CheckoutViewBody extends StatefulWidget {
  const _CheckoutViewBody();

  @override
  State<_CheckoutViewBody> createState() => _CheckoutViewBodyState();
}

class _CheckoutViewBodyState extends State<_CheckoutViewBody> {
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currency = context.tr('currency');

    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutLoaded && state.message != null && state.message!.isNotEmpty) {
          AppToast.error(context, message: state.message!);
        } else if (state is CheckoutError) {
          AppToast.error(context, message: state.message);
        } else if (state is CheckoutOrderSuccess) {
          AppToast.success(context, message: context.tr('orderSuccess'));
          context.go(AppRoutes.orderDetails, extra: state.order.id);
        }
      },
      builder: (context, state) {
        final cubit = context.read<CheckoutCubit>();

        if (state is CheckoutLoading) {
          return Scaffold(
            backgroundColor: context.scaffoldBackgroundColor,
            appBar: CustomAppBar(title: context.tr('checkout')),
            body: Center(
              child: CircularProgressIndicator(color: context.primaryThemeColor),
            ),
          );
        }

        if (state is CheckoutError && state is! CheckoutLoaded) {
          return Scaffold(
            backgroundColor: context.scaffoldBackgroundColor,
            appBar: CustomAppBar(title: context.tr('checkout')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, size: 50.sp, color: AppColors.error),
                  Gap(12.h),
                  Text(state.message, style: AppTextStyles.bodyLarge),
                  Gap(16.h),
                  ElevatedButton(
                    onPressed: () => cubit.loadCheckout(),
                    child: Text(context.tr('retry')),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is CheckoutLoaded || state is CheckoutPlacingOrder) {
          final checkout = (state is CheckoutLoaded)
              ? state.checkout
              : (state as dynamic).checkout;
          final address = checkout?.selectedAddress;
          final availablePaymentMethods = checkout?.availablePaymentMethods ?? [];
          final selectedPaymentId = (state is CheckoutLoaded)
              ? state.selectedPaymentMethodId
              : checkout?.selectedPaymentMethodId;
          final isEligible = checkout?.isEligibleToCheckout ?? true;
          final issues = checkout?.issues ?? [];
          final cart = checkout?.cart;

          final subtotal = cart?.subtotal ?? 0.0;
          final deliveryFee = cart?.deliveryFee ?? 0.0;
          final total = cart?.total ?? 0.0;

          return Scaffold(
            backgroundColor: context.scaffoldBackgroundColor,
            appBar: CustomAppBar(title: context.tr('checkout')),
            body: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              children: [
                if (!isEligible || issues.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.error),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 24.sp),
                        Gap(10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: issues.map((issue) => Text(
                              issue.message,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.bold,
                              ),
                            )).toList(),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms),

                Text(
                  context.tr('deliveryLocation'),
                  style: AppTextStyles.headingSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
                SizedBox(height: 10.h),
                CheckoutSectionCard(
                  icon: Icons.location_on_outlined,
                  label: address != null ? (address.label ?? context.tr('selectAddress')) : context.tr('selectAddress'),
                  value: address != null ? address.fullAddressText : context.tr('noAddressSelected'),
                  onChange: () async {
                    final selected = await context.push<Address>(AppRoutes.addressList);
                    if (selected != null) {
                      cubit.selectAddress(selected.id);
                    } else {
                      cubit.loadCheckout();
                    }
                  },
                ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0),

                SizedBox(height: 20.h),

                Text(
                  context.tr('paymentMethod'),
                  style: AppTextStyles.headingSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
                SizedBox(height: 10.h),
                if (availablePaymentMethods.isEmpty)
                  Text(
                    context.tr('noPaymentMethods'),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: context.textSecondaryColor,
                    ),
                  )
                else
                  Column(
                    children: availablePaymentMethods.map((method) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: PaymentMethodTile(
                          icon: Icons.payment_rounded,
                          label: method.name,
                          selected: selectedPaymentId == method.id,
                          onTap: () => cubit.selectPaymentMethod(method.id),
                        ),
                      );
                    }).toList(),
                  ).animate().fadeIn(delay: 100.ms, duration: 350.ms),

                SizedBox(height: 16.h),

                Text(
                  context.tr('deliveryInstructions'),
                  style: AppTextStyles.headingSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
                SizedBox(height: 10.h),
                AppTextField(
                  controller: _notesController,
                  hint: context.tr('deliveryNotesHint'),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                SizedBox(height: 24.h),

                OrderSummaryWidget(
                  subtotal: subtotal,
                  deliveryFee: deliveryFee,
                  total: total,
                ).animate().fadeIn(delay: 250.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: AppButton(
                  label: isEligible
                      ? '${context.tr('placeOrder')} • ${total.toStringAsFixed(0)} $currency'
                      : context.tr('notEligibleToCheckout'),
                  icon: Icons.check_circle_rounded,
                  isLoading: state is CheckoutPlacingOrder,
                  onPressed: (isEligible && state is! CheckoutPlacingOrder)
                      ? () => cubit.placeOrder(_notesController.text.trim())
                      : null,
                ),
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
