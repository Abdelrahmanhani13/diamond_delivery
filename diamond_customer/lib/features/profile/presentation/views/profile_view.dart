import 'package:diamond_customer/core/widgets/app_bottom_nav_bar.dart';
import 'package:diamond_customer/features/profile/presentation/views/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_title.dart';
import '../../../../core/di/service_locator.dart';
import '../../domain/entities/profile_entity.dart';
import '../controller/profile_cubit.dart';
import '../controller/profile_state.dart';
import '../widgets/profile_stat_card.dart';
import '../widgets/profile_menu_item.dart';
import 'package:diamond_customer/features/auth/domain/usecases/logout_use_case.dart';
import 'package:diamond_customer/features/auth/data/data_sources/auth_local_data_source.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..fetchProfile(),
      child: const _ProfileViewBody(),
    );
  }
}

class _ProfileViewBody extends StatelessWidget {
  const _ProfileViewBody();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: Column(
            children: [
              // Custom Top Header Title
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'الملف الشخصي',
                      style: AppTextStyles.headingLarge.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading || state is ProfileInitial) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    if (state is ProfileError) {
                      return Center(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(24.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 56.sp,
                                color: AppColors.error,
                              ),
                              Gap(16.h),
                              Text(
                                'تعذر تحميل بيانات الملف الشخصي',
                                style: AppTextStyles.headingSmall.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Gap(8.h),
                              Text(
                                state.message,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Gap(24.h),
                              AppButton(
                                label: 'إعادة المحاولة',
                                icon: Icons.refresh_rounded,
                                variant: AppButtonVariant.outline,
                                onPressed: () =>
                                    context.read<ProfileCubit>().fetchProfile(),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    ProfileEntity? profile;
                    if (state is ProfileLoaded) {
                      profile = state.profile;
                    } else if (state is ProfileUpdateSuccess) {
                      profile = state.profile;
                    }

                    final walletVal = profile != null
                        ? '${profile.walletBalance.toStringAsFixed(0)} ر.س'
                        : '0 ر.س';
                    final ratingVal = profile != null
                        ? profile.userRating.toStringAsFixed(1)
                        : '5.0';
                    final completedOrdersVal = profile != null
                        ? '${profile.completedOrdersCount}'
                        : '0';

                    return ListView(
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                      children: [
                        // Header card
                        const ProfileHeader()
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: -0.05, end: 0),

                        Gap(16.h),

                        // Stats row (Wallet / Rating / Orders)
                        Row(
                          children: [
                            ProfileStatCard(
                              value: walletVal,
                              label: 'المحفظة',
                              icon: Icons.account_balance_wallet_outlined,
                            ),
                            ProfileStatCard(
                              value: ratingVal,
                              label: 'التقييم',
                              icon: Icons.star_rounded,
                            ),
                            ProfileStatCard(
                              value: completedOrdersVal,
                              label: 'طلب مكتمل',
                              icon: Icons.receipt_long_outlined,
                            ),
                          ],
                        ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

                        Gap(20.h),

                        // Main Operations Block
                        const SectionTitle(title: 'العمليات الأساسية'),
                        Gap(8.h),
                        AppCard(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 4.h,
                          ),
                          child: Column(
                            children: [
                              ProfileMenuItem(
                                icon: Icons.location_on_outlined,
                                label: 'عناويني المحفوظة',
                                onTap: () =>
                                    context.push(AppRoutes.addressList),
                              ),
                              const Divider(height: 1, indent: 56),
                              ProfileMenuItem(
                                icon: Icons.account_balance_wallet_outlined,
                                label: 'رصيد المحفظة',
                                trailingText: walletVal,
                                onTap: () {},
                              ),
                              const Divider(height: 1, indent: 56),
                              ProfileMenuItem(
                                icon: Icons.favorite_border_rounded,
                                label: 'المتاجر والمنتجات المفضلة',
                                onTap: () => context.push(AppRoutes.favorites),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

                        Gap(24.h),

                        // Logout button
                        AppButton(
                          label: 'تسجيل خروج',
                          variant: AppButtonVariant.danger,
                          icon: Icons.logout_rounded,
                          onPressed: () => _showLogoutDialog(context),
                        ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: 0,
          onTap: (index) => _onNavTap(context, index),
        ),
      ),
    );
  }

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.profile);
        break;
      case 1:
        context.go(AppRoutes.orders);
        break;
      case 2:
        context.push(AppRoutes.search);
        break;
      case 3:
        context.go(AppRoutes.home);
        break;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تسجيل خروج'),
        content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              final authLocal = getIt<AuthLocalDataSource>();
              final logoutUseCase = getIt<LogoutUseCase>();

              final refreshToken = await authLocal.getRefreshToken();
              if (refreshToken != null) {
                await logoutUseCase(refreshToken);
              } else {
                await authLocal.clearAll();
              }

              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
            child: const Text(
              'تسجيل خروج',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
