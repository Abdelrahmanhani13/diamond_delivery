import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_radius.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.greyLightColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _stepButton(context: context, icon: Icons.remove_rounded, onTap: onDecrement),
          SizedBox(
            width: 28.w,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: context.textPrimaryColor,
              ),
            ),
          ),
          _stepButton(context: context, icon: Icons.add_rounded, onTap: onIncrement, filled: true),
        ],
      ),
    );
  }

  Widget _stepButton({required BuildContext context, required IconData icon, required VoidCallback onTap, bool filled = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          color: filled ? context.primaryThemeColor : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16.sp, color: filled ? AppColors.white : context.textSecondaryColor),
      ),
    );
  }
}
