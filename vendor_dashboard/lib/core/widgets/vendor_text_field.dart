import 'package:flutter/material.dart';
import '../theme/vendor_colors.dart';
import '../theme/vendor_text_styles.dart';

class VendorTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextDirection? textDirection;

  const VendorTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textDirection: textDirection,
      maxLines: maxLines,
      style: VendorTextStyles.bodyMedium,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: VendorColors.grey)
            : null,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
