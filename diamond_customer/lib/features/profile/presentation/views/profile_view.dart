import 'package:diamond_customer/core/localization/app_localizations.dart';
import 'package:diamond_customer/core/settings/settings_cubit.dart';
import 'package:diamond_customer/core/settings/settings_state.dart';
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
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
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
                    context.tr('profile'),
                    style: AppTextStyles.headingLarge.copyWith(
                      fontWeight: FontWeight.w900,
                      color: context.textPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading || state is ProfileInitial) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: context.primaryThemeColor,
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
                              context.tr('errorOccurred'),
                              style: AppTextStyles.headingSmall.copyWith(
                                color: context.textPrimaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Gap(8.h),
                            Text(
                              state.message,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: context.textSecondaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Gap(24.h),
                            AppButton(
                              label: context.tr('retry'),
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
                      ? '${profile.walletBalance.toStringAsFixed(0)} ${context.tr('currency')}'
                      : '0 ${context.tr('currency')}';
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
                            label: context.tr('wallet'),
                            icon: Icons.account_balance_wallet_outlined,
                          ),
                          ProfileStatCard(
                            value: ratingVal,
                            label: context.tr('rating'),
                            icon: Icons.star_rounded,
                          ),
                          ProfileStatCard(
                            value: completedOrdersVal,
                            label: context.tr('completedOrders'),
                            icon: Icons.receipt_long_outlined,
                          ),
                        ],
                      ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

                      Gap(20.h),

                      // Main Operations Block
                      SectionTitle(title: context.tr('mainOperations')),
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
                              label: context.tr('addresses'),
                              onTap: () => context.push(AppRoutes.addressList),
                            ),
                            const Divider(height: 1, indent: 56),
                            ProfileMenuItem(
                              icon: Icons.account_balance_wallet_outlined,
                              label: context.tr('walletBalance'),
                              trailingText: walletVal,
                              onTap: () {},
                            ),
                            const Divider(height: 1, indent: 56),
                            ProfileMenuItem(
                              icon: Icons.favorite_border_rounded,
                              label: context.tr('favorites'),
                              onTap: () => context.push(AppRoutes.favorites),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

                      Gap(16.h),

                      // App Settings Block (Theme & Language)
                      SectionTitle(title: context.tr('appSettings')),
                      Gap(8.h),
                      BlocBuilder<SettingsCubit, SettingsState>(
                        builder: (context, settingsState) {
                          final isDark =
                              settingsState.themeMode == ThemeMode.dark;
                          final isAr =
                              settingsState.locale.languageCode == 'ar';

                          return AppCard(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 4.h,
                            ),
                            child: Column(
                              children: [
                                ProfileMenuItem(
                                  icon: isDark
                                      ? Icons.dark_mode_outlined
                                      : Icons.light_mode_outlined,
                                  label: context.tr('themeMode'),
                                  trailingText: isDark ? 'Dark' : 'Light',
                                  onTap: () => context
                                      .read<SettingsCubit>()
                                      .toggleTheme(),
                                ),
                                const Divider(height: 1, indent: 56),
                                ProfileMenuItem(
                                  icon: Icons.language_rounded,
                                  label: context.tr('language'),
                                  trailingText: isAr ? 'العربية' : 'English',
                                  onTap: () => context
                                      .read<SettingsCubit>()
                                      .toggleLocale(),
                                ),
                              ],
                            ),
                          );
                        },
                      ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                      Gap(24.h),

                      // Logout button
                      AppButton(
                        label: context.tr('logout'),
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
        title: Text(context.tr('logoutConfirmTitle')),
        content: Text(context.tr('logoutConfirmMessage')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.tr('cancel')),
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
            child: Text(
              context.tr('logout'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
