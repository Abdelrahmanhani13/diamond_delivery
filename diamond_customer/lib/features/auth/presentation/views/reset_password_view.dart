import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controller/cubits/reset_password/reset_password_cubit.dart';
import '../controller/cubits/reset_password/reset_password_state.dart';
import '../widgets/auth_header.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key, required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ResetPasswordCubit>(),
      child: _ResetPasswordForm(email: email, otp: otp),
    );
  }
}

class _ResetPasswordForm extends StatefulWidget {
  const _ResetPasswordForm({required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  State<_ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<_ResetPasswordForm> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _submitted = false;

  String? get _passwordError =>
      _submitted ? PasswordValidator.validate(_passwordController.text) : null;

  String? get _confirmError => _submitted
      ? ConfirmPasswordValidator.validate(
          _confirmController.text,
          _passwordController.text,
        )
      : null;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _submitted = true);
    if (_passwordError != null || _confirmError != null) return;

    context.read<ResetPasswordCubit>().resetPassword(
      widget.email,
      widget.otp,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: BlocListener<ResetPasswordCubit, ResetPasswordState>(
            listener: (context, state) {
              if (state is ResetPasswordSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح')),
                );
                context.go(AppRoutes.login);
              } else if (state is ResetPasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AuthHeader(
                    title: 'كلمة مرور جديدة',
                    subtitle: 'اختر كلمة مرور قوية لحسابك',
                  ),
                  SizedBox(height: 32.h),
                  AppTextField(
                    controller: _passwordController,
                    label: 'كلمة المرور الجديدة',
                    hint: '••••••••',
                    obscureText: _obscure1,
                    prefixIcon: Icons.lock_outline_rounded,
                    errorText: _passwordError,
                    onChanged: (_) => setState(() {}),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure1
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20.sp,
                      ),
                      onPressed: () => setState(() => _obscure1 = !_obscure1),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    controller: _confirmController,
                    label: 'تأكيد كلمة المرور',
                    hint: '••••••••',
                    obscureText: _obscure2,
                    prefixIcon: Icons.lock_outline_rounded,
                    errorText: _confirmError,
                    onChanged: (_) => setState(() {}),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure2
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20.sp,
                      ),
                      onPressed: () => setState(() => _obscure2 = !_obscure2),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'يجب أن تحتوي على 8 أحرف على الأقل',
                    style: AppTextStyles.bodySmall,
                  ),
                  SizedBox(height: 24.h),
                  BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                    builder: (context, state) {
                      final isLoading = state is ResetPasswordLoading;
                      return AppButton(
                        label: isLoading ? 'جاري الحفظ...' : 'حفظ كلمة المرور',
                        onPressed: isLoading ? null : _submit,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
