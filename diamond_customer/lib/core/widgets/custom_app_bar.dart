import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onBack,
    this.showBack = true,
  });

  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final bool showBack;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.surfaceColor,
      surfaceTintColor: context.surfaceColor,
      leading: showBack
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18.sp,
                color: context.textPrimaryColor,
              ),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      title: Text(
        title,
        style: AppTextStyles.headingSmall.copyWith(
          color: context.textPrimaryColor,
        ),
      ),
      actions: actions,
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.headingSmall.copyWith(
            color: context.textPrimaryColor,
          ),
        ),
        if (actionLabel != null)
          InkWell(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: AppTextStyles.link.copyWith(
                color: context.primaryThemeColor,
              ),
            ),
          ),
      ],
    );
  }
}
