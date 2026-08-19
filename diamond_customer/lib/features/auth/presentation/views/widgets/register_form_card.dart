import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_text_field.dart';

class RegisterFormCard extends StatelessWidget {
  const RegisterFormCard({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.dobController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onPickDateOfBirth,
    this.firstNameError,
    this.lastNameError,
    this.emailError,
    this.phoneError,
    this.passwordError,
    this.onFirstNameChanged,
    this.onLastNameChanged,
    this.onEmailChanged,
    this.onPhoneChanged,
    this.onPasswordChanged,
    required this.submitButton,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController dobController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onPickDateOfBirth;
  final String? firstNameError;
  final String? lastNameError;
  final String? emailError;
  final String? phoneError;
  final String? passwordError;
  final ValueChanged<String>? onFirstNameChanged;
  final ValueChanged<String>? onLastNameChanged;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPhoneChanged;
  final ValueChanged<String>? onPasswordChanged;
  final Widget submitButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: firstNameController,
                  label: context.tr('firstName'),
                  hint: 'John',
                  prefixIcon: Icons.person_outline_rounded,
                  errorText: firstNameError,
                  onChanged: onFirstNameChanged,
                ),
              ),
              Gap(16.w),
              Expanded(
                child: AppTextField(
                  controller: lastNameController,
                  label: context.tr('lastName'),
                  hint: 'Doe',
                  prefixIcon: Icons.person_outline_rounded,
                  errorText: lastNameError,
                  onChanged: onLastNameChanged,
                ),
              ),
            ],
          ),

          Gap(16.h),

          AppTextField(
            controller: emailController,
            label: context.tr('email'),
            hint: 'john.doe@example.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            errorText: emailError,
            onChanged: onEmailChanged,
          ),

          Gap(16.h),

          AppTextField(
            controller: phoneController,
            label: context.tr('phoneNumber'),
            hint: '01012345678',
            prefixIcon: Icons.phone_iphone_rounded,
            keyboardType: TextInputType.phone,
            errorText: phoneError,
            onChanged: onPhoneChanged,
          ),

          Gap(16.h),

          AppTextField(
            controller: passwordController,
            label: context.tr('password'),
            hint: '••••••••',
            obscureText: obscurePassword,
            prefixIcon: Icons.lock_outline_rounded,
            errorText: passwordError,
            onChanged: onPasswordChanged,
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20.sp,
                color: context.textSecondaryColor,
              ),
              onPressed: onToggleObscure,
            ),
          ),

          Gap(16.h),

          GestureDetector(
            onTap: onPickDateOfBirth,
            child: AbsorbPointer(
              child: AppTextField(
                controller: dobController,
                label: context.isArabic ? 'تاريخ الميلاد (اختياري)' : 'Date of Birth (Optional)',
                hint: '2000-05-14',
                prefixIcon: Icons.cake_outlined,
                suffixIcon: Icon(
                  Icons.calendar_today_outlined,
                  size: 20.sp,
                  color: context.textSecondaryColor,
                ),
              ),
            ),
          ),

          Gap(24.h),

          submitButton,
        ],
      ),
    );
  }
}
