import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controller/cubits/otp/otp_cubit.dart';
import '../controller/cubits/otp/otp_state.dart';
import '../widgets/auth_header.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OtpCubit>(),
      child: const _ForgotPasswordForm(),
    );
  }
}

class _ForgotPasswordForm extends StatefulWidget {
  const _ForgotPasswordForm();

  @override
  State<_ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<_ForgotPasswordForm> {
  final _phoneController = TextEditingController();
  bool _submitted = false;

  String? get _phoneError =>
      _submitted ? PhoneValidator.validate(_phoneController.text) : null;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _submitted = true);
    if (_phoneError != null) return;
    context.read<OtpCubit>().requestOtp(
      _phoneController.text.trim(),
      'ResetPassword',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18.sp,
            color: context.textPrimaryColor,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: BlocListener<OtpCubit, OtpState>(
          listener: (context, state) {
            if (state is OtpResentSuccess) {
              context.push(
                AppRoutes.otpVerification,
                extra: {
                  'phoneNumber': _phoneController.text.trim(),
                  'isPasswordReset': true,
                },
              );
            } else if (state is OtpError) {
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
                AuthHeader(
                  title: context.tr('resetPasswordTitle'),
                  subtitle: context.tr('resetPasswordSubtitle'),
                ),
                SizedBox(height: 32.h),
                AppTextField(
                  controller: _phoneController,
                  label: context.tr('phoneNumber'),
                  hint: '01xxxxxxxxx',
                  prefixIcon: Icons.phone_android_outlined,
                  keyboardType: TextInputType.phone,
                  errorText: _phoneError,
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: 24.h),
                BlocBuilder<OtpCubit, OtpState>(
                  builder: (context, state) {
                    final isLoading = state is OtpLoading;
                    return AppButton(
                      label: isLoading ? context.tr('loading') : context.tr('sendCode'),
                      onPressed: isLoading ? null : _submit,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
