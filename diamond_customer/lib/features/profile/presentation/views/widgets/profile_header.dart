import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_asset_image.dart';
import '../../controller/profile_cubit.dart';
import '../../controller/profile_state.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        String name = 'جاري التحميل...';
        String phone = '';
        String badge = 'عضو ذهبي مميز';

        if (state is ProfileLoaded) {
          final fullName =
              '${state.profile.firstName} ${state.profile.lastName}'.trim();
          name = fullName.isNotEmpty
              ? fullName
              : (state.profile.phoneNumber.isNotEmpty
                    ? state.profile.phoneNumber
                    : 'المستخدم');
          phone = state.profile.phoneNumber;
          badge = state.profile.membershipBadge;
        } else if (state is ProfileUpdateSuccess) {
          final fullName =
              '${state.profile.firstName} ${state.profile.lastName}'.trim();
          name = fullName.isNotEmpty
              ? fullName
              : (state.profile.phoneNumber.isNotEmpty
                    ? state.profile.phoneNumber
                    : 'المستخدم');
          phone = state.profile.phoneNumber;
          badge = state.profile.membershipBadge;
        } else if (state is ProfileError) {
          name = 'خطأ في التحميل';
          phone = '';
        }

        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.5),
                    width: 3.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 36.r,
                  backgroundColor: AppColors.white,
                  child: ClipOval(
                    child: AppAssetImage(
                      assetPath: Assets.images.avatarPlaceholder,
                      width: 72.w,
                      height: 72.w,
                      fit: BoxFit.cover,
                      fallbackIcon: Icons.person_rounded,
                    ),
                  ),
                ),
              ),
              Gap(16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(4.h),
                    if (phone.isNotEmpty)
                      Text(
                        phone,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.white.withValues(alpha: 0.85),
                          letterSpacing: 0.5,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                    Gap(8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            HugeIcons.strokeRoundedAward01,
                            size: 14.sp,
                            color: AppColors.accent,
                          ),
                          Gap(4.w),
                          Text(
                            badge,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
