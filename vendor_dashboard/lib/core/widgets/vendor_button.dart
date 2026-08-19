import 'package:flutter/material.dart';
import '../theme/vendor_colors.dart';
import '../theme/vendor_text_styles.dart';

enum VendorButtonVariant { primary, outline, danger }

class VendorButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final VendorButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final double? width;

  const VendorButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = VendorButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    BorderSide? borderSide;

    switch (variant) {
      case VendorButtonVariant.primary:
        bgColor = VendorColors.primary;
        fgColor = VendorColors.white;
        break;
      case VendorButtonVariant.outline:
        bgColor = Colors.transparent;
        fgColor = VendorColors.primary;
        borderSide = const BorderSide(color: VendorColors.primary);
        break;
      case VendorButtonVariant.danger:
        bgColor = VendorColors.error;
        fgColor = VendorColors.white;
        break;
    }

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: 0,
      side: borderSide,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    );

    final textWidget = Text(
      label,
      style: VendorTextStyles.buttonMedium.copyWith(color: fgColor),
    );

    Widget child;
    if (isLoading) {
      child = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: fgColor),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: fgColor),
          const SizedBox(width: 8),
          textWidget,
        ],
      );
    } else {
      child = textWidget;
    }

    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: child,
      ),
    );
  }
}
