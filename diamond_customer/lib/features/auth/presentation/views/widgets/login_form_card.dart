import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../controller/cubits/login/login_cubit.dart';
import '../../controller/cubits/login/login_state.dart';

class LoginFormCard extends StatelessWidget {
  const LoginFormCard({
    super.key,
    required this.phoneController,
    required this.passwordController,
    required this.phoneError,
    required this.passwordError,
    required this.obscure,
    required this.onPhoneChanged,
    required this.onPasswordChanged,
    required this.onObscureToggle,
    required this.onSubmit,
  });

  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final String? phoneError;
  final String? passwordError;
  final bool obscure;
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onObscureToggle;
  final VoidCallback onSubmit;

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
          AppTextField(
            controller: phoneController,
            label: context.tr('phoneNumber'),
            hint: '01xxxxxxxxx',
            prefixIcon: Icons.phone_android_outlined,
            keyboardType: TextInputType.phone,
            errorText: phoneError,
            onChanged: onPhoneChanged,
          ),

          Gap(16.h),

          AppTextField(
            controller: passwordController,
            label: context.tr('password'),
            hint: '••••••••',
            obscureText: obscure,
            prefixIcon: Icons.lock_outline_rounded,
            errorText: passwordError,
            onChanged: onPasswordChanged,
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20.sp,
              ),
              onPressed: onObscureToggle,
            ),
          ),

          Gap(12.h),

          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => context.push(AppRoutes.forgotPassword),
              child: Text(context.tr('forgotPassword')),
            ),
          ),

          Gap(20.h),

          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              final isLoading = state is LoginLoading;
              return AppButton(
                label: isLoading ? context.tr('loading') : context.tr('login'),
                onPressed: isLoading ? null : onSubmit,
              );
            },
          ),
        ],
      ),
    );
  }
}
