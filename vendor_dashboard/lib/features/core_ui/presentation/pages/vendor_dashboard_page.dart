import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor_dashboard/core/di/service_locator.dart';
import 'package:vendor_dashboard/core/theme/vendor_colors.dart';
import 'package:vendor_dashboard/core/theme/vendor_text_styles.dart';
import 'package:vendor_dashboard/features/products/presentation/controller/vendor_products_cubit/vendor_products_cubit.dart';
import 'package:vendor_dashboard/features/products/presentation/pages/vendor_products_list_page.dart';
import 'package:vendor_dashboard/features/profile/presentation/controller/profile_cubit/vendor_profile_cubit.dart';
import 'package:vendor_dashboard/features/profile/presentation/pages/vendor_profile_page.dart';

class VendorDashboardPage extends StatefulWidget {
  const VendorDashboardPage({super.key});

  @override
  State<VendorDashboardPage> createState() => _VendorDashboardPageState();
}

class _VendorDashboardPageState extends State<VendorDashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    VendorProductsListPage(),

    // TODO: Replace with VendorOrdersPage when orders feature is implemented.
    Center(child: Text('الطلبات - قريباً')),

    VendorProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VendorProductsCubit>(
          create: (_) => getIt<VendorProductsCubit>(),
        ),

        BlocProvider<VendorProfileCubit>(
          create: (_) => getIt<VendorProfileCubit>(),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: IndexedStack(index: _currentIndex, children: _pages),

          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: VendorColors.surface,
              boxShadow: [
                BoxShadow(
                  color: VendorColors.shadow,
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavBarItem(
                      icon: Icons.inventory_2_outlined,
                      activeIcon: Icons.inventory_2_rounded,
                      label: 'منتجاتي',
                      isSelected: _currentIndex == 0,
                      onTap: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                    ),

                    _NavBarItem(
                      icon: Icons.receipt_long_outlined,
                      activeIcon: Icons.receipt_long_rounded,
                      label: 'الطلبات',
                      isSelected: _currentIndex == 1,
                      onTap: () {
                        setState(() {
                          _currentIndex = 1;
                        });
                      },
                    ),

                    _NavBarItem(
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                      label: 'حسابي',
                      isSelected: _currentIndex == 2,
                      onTap: () {
                        setState(() {
                          _currentIndex = 2;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? VendorColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? VendorColors.primary : VendorColors.grey,
              size: 24,
            ),

            if (isSelected) ...[
              const SizedBox(width: 8),

              Text(
                label,
                style: VendorTextStyles.bodyMedium.copyWith(
                  color: VendorColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
