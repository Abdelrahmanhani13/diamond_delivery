import 'package:diamond_customer/features/addresses/presentation/controller/location_picker_cubit/location_picker_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_button.dart';

/// A bottom sheet card displaying the selected location's details
/// and a button to confirm the address.
class LocationDetailsBottomSheet extends StatelessWidget {
  const LocationDetailsBottomSheet({
    super.key,
    required this.state,
    required this.onConfirm,
  });

  final LocationPickerState state;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(top: false, child: _buildContent(context)),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (state is LocationPickerLoading || state is LocationPickerInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is LocationPickerLoaded) {
      final loadedState = state as LocationPickerLoaded;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loadedState.address.street.isNotEmpty
                          ? loadedState.address.street
                          : loadedState.address.displayName,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(2.h),
                    Text(
                      '${loadedState.address.city}, ${loadedState.address.country}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(20.h),
          AppButton(
            label: 'تأكيد هذا العنوان',
            icon: Icons.check_circle_outline_rounded,
            onPressed: onConfirm,
          ),
        ],
      );
    }

    return const Center(child: Text('عذراً، حدث خطأ أثناء تحديد الموقع'));
  }
}
