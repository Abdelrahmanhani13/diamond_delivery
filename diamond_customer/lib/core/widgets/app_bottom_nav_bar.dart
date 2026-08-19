import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../localization/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItemData(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        key: 'profile',
      ),
      _NavItemData(
        icon: Icons.receipt_long_outlined,
        activeIcon: Icons.receipt_long_rounded,
        key: 'orders',
      ),
      _NavItemData(
        icon: Icons.search_rounded,
        activeIcon: Icons.search_rounded,
        key: 'search',
      ),
      _NavItemData(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        key: 'home',
      ),
    ];

    return Container(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final bool selected = index == currentIndex;
            return _NavTile(
              item: item,
              selected: selected,
              onTap: () => onTap(index),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.icon,
    required this.activeIcon,
    required this.key,
  });

  final IconData icon;
  final IconData activeIcon;
  final String key;
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItemData item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = context.primaryThemeColor;
    final unselectedColor = context.textSecondaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? item.activeIcon : item.icon,
              size: 22.sp,
              color: selected ? AppColors.textOnPrimary : unselectedColor,
            ),
            if (!selected) ...[
              SizedBox(height: 4.h),
              Text(
                context.tr(item.key),
                style: AppTextStyles.caption.copyWith(color: unselectedColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
