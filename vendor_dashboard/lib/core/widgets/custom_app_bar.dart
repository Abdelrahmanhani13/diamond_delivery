import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_text_styles.dart';

/// Consistent app bar used across secondary screens (Cart, Notifications,
/// Search, Order Details, Settings, ...). Home screen uses its own custom
/// header (see HomeHeader) since it isn't a plain title bar.
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
  Size get preferredSize => Size.fromHeight(70.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      title: Text(title, style: AppTextStyles.headingSmall),
      actions: actions,
    );
  }
}

/// Section header used inside scrollable content, e.g. "التصنيفات" /
/// "الأكثر طلباً" with an optional "عرض الكل" trailing action.
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
        Text(title, style: AppTextStyles.headingSmall),
        if (actionLabel != null)
          InkWell(
            onTap: onAction,
            child: Text(actionLabel!, style: AppTextStyles.link),
          ),
      ],
    );
  }
}
