import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:diamond_customer/core/di/service_locator.dart';
import 'package:diamond_customer/core/localization/app_localizations.dart';
import 'package:diamond_customer/core/utils/app_toast.dart';
import 'package:diamond_customer/features/cart/presentation/controller/cart_cubit.dart';
import 'package:diamond_customer/features/cart/presentation/controller/cart_state.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_button.dart';

class AddToCartBottomBar extends StatefulWidget {
  const AddToCartBottomBar({
    super.key,
    required this.productId,
    required this.price,
    required this.quantity,
  });

  final String productId;
  final double price;
  final int quantity;

  @override
  State<AddToCartBottomBar> createState() => _AddToCartBottomBarState();
}

class _AddToCartBottomBarState extends State<AddToCartBottomBar> {
  bool _isLoading = false;

  Future<void> _handleAddToCart() async {
    setState(() => _isLoading = true);
    await getIt<CartCubit>().addToCart(widget.productId, widget.quantity);
    if (!mounted) return;
    setState(() => _isLoading = false);

    final cartState = getIt<CartCubit>().state;
    if (cartState is CartLoaded) {
      if (cartState.message != null && cartState.message!.isNotEmpty) {
        AppToast.error(context, message: cartState.message!);
      } else {
        AppToast.success(context, message: context.tr('addedToCartSuccess'));
      }
    } else if (cartState is CartError) {
      AppToast.error(context, message: cartState.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = context.tr('currency');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: AppButton(
        label:
            '${context.tr('addToCart')} • ${(widget.price * widget.quantity).toStringAsFixed(0)} $currency',
        icon: Icons.shopping_cart_rounded,
        isLoading: _isLoading,
        onPressed: _handleAddToCart,
      ),
    );
  }
}
