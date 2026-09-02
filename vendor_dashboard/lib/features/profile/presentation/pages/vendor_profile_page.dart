import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/language_cubit.dart';
import '../../../../core/localization/language_state.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';
import '../../../../core/utils/localized_entity_extension.dart';
import '../../../auth/presentation/controller/auth_cubit/vendor_auth_cubit.dart';
import '../controller/profile_cubit/vendor_profile_cubit.dart';
import '../controller/profile_cubit/vendor_profile_state.dart';
import '../widgets/vendor_dashboard_stats_grid.dart';
import '../widgets/vendor_profile_header.dart';
import '../widgets/vendor_profile_info_section.dart';

class VendorProfilePage extends StatefulWidget {
  const VendorProfilePage({super.key});

  @override
  State<VendorProfilePage> createState() => _VendorProfilePageState();
}

class _VendorProfilePageState extends State<VendorProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<VendorProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VendorColors.scaffoldBackground,
      body: BlocBuilder<VendorProfileCubit, VendorProfileState>(
        builder: (context, state) {
          if (state is VendorProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: VendorColors.primary),
            );
          }

          if (state is VendorProfileError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 56,
                      color: VendorColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.tr('loadProfileError'),
                      style: VendorTextStyles.headingSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: VendorTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            context.read<VendorProfileCubit>().fetchProfile();
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(context.tr('retry')),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.go(RoutePaths.profileSetup);
                          },
                          icon: const Icon(Icons.add_business_rounded),
                          label: Text(context.tr('setupStore')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: VendorColors.primary,
                            foregroundColor: VendorColors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextButton.icon(
                      onPressed: () {
                        context.read<VendorAuthCubit>().loggedOut();
                      },
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: VendorColors.error,
                      ),
                      label: Text(
                        context.tr('logout'),
                        style: const TextStyle(color: VendorColors.error),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is VendorProfileLoaded) {
            final profile = state.profile;
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<VendorProfileCubit>().fetchProfile(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    VendorProfileHeader(
                      profile: profile,
                      isUpdatingStatus: state.isUpdatingStatus,
                      onToggleStatus: (val) {
                        context.read<VendorProfileCubit>().toggleOpenStatus(
                          val,
                        );
                      },
                      onLogoPicked: (file) {
                        context.read<VendorProfileCubit>().uploadLogo(file);
                      },
                      onCoverPicked: (file) {
                        context.read<VendorProfileCubit>().uploadCover(file);
                      },
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          if (state.stats != null) ...[
                            VendorDashboardStatsGrid(stats: state.stats!),
                            const SizedBox(height: 20),
                          ],
                          VendorProfileInfoSection(profile: profile),
                          const SizedBox(height: 16),
                          // Language Switcher Tile
                          BlocBuilder<LanguageCubit, LanguageState>(
                            builder: (context, langState) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: VendorColors.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: VendorColors.shadow,
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.language_rounded,
                                          color: VendorColors.primary,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          context.tr('language'),
                                          style: VendorTextStyles.bodyMedium
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        context
                                            .read<LanguageCubit>()
                                            .toggleLanguage();
                                      },
                                      icon: const Icon(
                                        Icons.swap_horiz_rounded,
                                        size: 20,
                                      ),
                                      label: Text(
                                        langState.isArabic
                                            ? 'English'
                                            : 'العربية',
                                        style: VendorTextStyles.bodyMedium
                                            .copyWith(
                                              color: VendorColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                context.read<VendorAuthCubit>().loggedOut();
                              },
                              icon: const Icon(
                                Icons.logout_rounded,
                                color: VendorColors.error,
                              ),
                              label: Text(
                                context.tr('logout'),
                                style: const TextStyle(
                                  color: VendorColors.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: VendorColors.error,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
