import 'package:vendor_dashboard/features/auth/data/datasources/vendor_auth_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_router.dart';
import '../../../auth/presentation/controller/auth_cubit/vendor_auth_cubit.dart';
import '../controller/profile_cubit/vendor_profile_cubit.dart';
import '../controller/profile_cubit/vendor_profile_state.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
                        'تعذر تحميل الملف الشخصي',
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
                            label: const Text('إعادة المحاولة'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.go(RoutePaths.profileSetup);
                            },
                            icon: const Icon(Icons.add_business_rounded),
                            label: const Text('إعداد المتجر'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: VendorColors.primary,
                              foregroundColor: VendorColors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Logout Button
                      TextButton.icon(
                        onPressed: () {
                          context.read<VendorAuthCubit>().loggedOut();
                        },
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: VendorColors.error,
                        ),
                        label: const Text(
                          'تسجيل الخروج',
                          style: TextStyle(color: VendorColors.error),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is VendorProfileLoaded ||
                state is VendorProfileUpdateSuccess) {
              final profile = (state is VendorProfileLoaded)
                  ? state.profile
                  : (state as VendorProfileUpdateSuccess).profile;

              return CustomScrollView(
                slivers: [
                  // Cover + Logo Header
                  SliverToBoxAdapter(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Cover
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: VendorColors.primaryGradient,
                          ),
                          child: profile.coverUrl != null
                              ? Image.network(
                                  profile.coverUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const SizedBox(),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.store_rounded,
                                    size: 80,
                                    color: VendorColors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                        ),
                        // Logo overlapping
                        Positioned(
                          bottom: -45,
                          right: 0,
                          left: 0,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: VendorColors.white,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: VendorColors.black.withValues(alpha: 0.1),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 45,
                                backgroundColor: VendorColors.greyLight,
                                backgroundImage: profile.logoUrl != null
                                    ? NetworkImage(profile.logoUrl!)
                                    : null,
                                child: profile.logoUrl == null
                                    ? const Icon(
                                        Icons.store_rounded,
                                        size: 40,
                                        color: VendorColors.grey,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        // Edit button
                        Positioned(
                          top: 40,
                          left: 16,
                          child: CircleAvatar(
                            backgroundColor: VendorColors.white.withValues(
                              alpha: 0.9,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit_rounded,
                                color: VendorColors.primary,
                                size: 20,
                              ),
                              onPressed: () async {
                                await context.push(
                                  RoutePaths.profileEdit,
                                  extra: profile,
                                );
                                if (context.mounted) {
                                  context
                                      .read<VendorProfileCubit>()
                                      .fetchProfile();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Spacing for logo overlap
                  const SliverToBoxAdapter(child: SizedBox(height: 55)),

                  // Store name + email
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            profile.storeName,
                            style: VendorTextStyles.headingLarge.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.email,
                            style: VendorTextStyles.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Info Cards
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          if (profile.phone != null)
                            _InfoCard(
                              icon: Icons.phone_outlined,
                              label: 'رقم الجوال',
                              value: profile.phone!,
                            ),
                          _InfoCard(
                            icon: Icons.location_on_outlined,
                            label: 'العنوان',
                            value: profile.address!,
                          ),
                          if (profile.description != null)
                            _InfoCard(
                              icon: Icons.info_outline_rounded,
                              label: 'نبذة عن المتجر',
                              value: profile.description!,
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Logout Button
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('تسجيل الخروج'),
                              content: const Text(
                                'هل أنت متأكد من تسجيل الخروج؟',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  child: const Text('إلغاء'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                    context.read<VendorAuthCubit>().loggedOut();
                                  },
                                  child: const Text(
                                    'خروج',
                                    style: TextStyle(color: VendorColors.error),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: VendorColors.error,
                        ),
                        label: Text(
                          'تسجيل الخروج',
                          style: VendorTextStyles.bodyMedium.copyWith(
                            color: VendorColors.error,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: VendorColors.error),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VendorColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: VendorColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: VendorColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: VendorColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: VendorTextStyles.caption),
                const SizedBox(height: 2),
                Text(value, style: VendorTextStyles.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
