import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/app_button.dart';
import '../controller/cubits/otp/otp_cubit.dart';
import '../controller/cubits/otp/otp_state.dart';
import 'auth_header.dart';
import '../views/widgets/otp_input_field.dart';
import '../views/widgets/otp_resend_button.dart';

/// طول كود الـ OTP — مصدر واحد للحقيقة يستخدمه الـ UI والـ Validator
/// معاً، عشان محدش يفضل يبعت كود بطول غلط للسيرفر.
const int kOtpLength = 6;
const int _resendCooldownSeconds = 180;

/// شاشة تأكيد الـ OTP — بتخدم تدفقين:
/// 1) تأكيد الحساب بعد التسجيل (isPasswordReset = false)
/// 2) تأكيد استعادة كلمة المرور (isPasswordReset = true)
class OtpVerificationView extends StatelessWidget {
  const OtpVerificationView({
    super.key,
    required this.phoneNumber,
    this.isPasswordReset = false,
  });

  final String phoneNumber;
  final bool isPasswordReset;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OtpCubit>(),
      child: _OtpForm(
        phoneNumber: phoneNumber,
        isPasswordReset: isPasswordReset,
      ),
    );
  }
}

class _OtpForm extends StatefulWidget {
  const _OtpForm({required this.phoneNumber, required this.isPasswordReset});

  final String phoneNumber;
  final bool isPasswordReset;

  @override
  State<_OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<_OtpForm> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

  Timer? _cooldownTimer;
  int _secondsLeft = 0;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _secondsLeft = _resendCooldownSeconds);
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  void _submit(String code) {
    if (code.length != kOtpLength) return;
    setState(() => _errorText = null);
    context.read<OtpCubit>().verifyOtp(
      widget.phoneNumber,
      code,
      widget.isPasswordReset ? 'ResetPassword' : 'Registration',
    );
  }

  void _resend() {
    if (_secondsLeft > 0) return;
    _pinController.clear();
    setState(() => _errorText = null);
    context.read<OtpCubit>().requestOtp(
      widget.phoneNumber,
      widget.isPasswordReset ? 'ResetPassword' : 'Registration',
    );
    _startCooldown();
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
          child: BlocListener<OtpCubit, OtpState>(
            listener: (context, state) {
              if (state is OtpSuccess) {
                if (widget.isPasswordReset) {
                  context.push(
                    AppRoutes.resetPassword,
                    extra: {
                      'phoneNumber': widget.phoneNumber,
                      'otp': _pinController.text,
                    },
                  );
                } else {
                  context.go(AppRoutes.home);
                }
              } else if (state is OtpResentSuccess) {
                AppToast.success(
                  context,
                  message: 'تم إرسال رمز جديد',
                  title: 'إعادة إرسال',
                );
              } else if (state is OtpError) {
                setState(() => _errorText = state.message);
                // بنمسح الكود القديم عشان المستخدم يقدر يدخل واحد
                // جديد فوراً، وبنرجّع الفوكس للحقل الأول.
                _pinController.clear();
                _focusNode.requestFocus();
                ScaffoldMessenger.of(context).clearSnackBars();
                AppToast.error(context, message: state.message);
              }
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthHeader(
                    title: 'تحقق من هاتفك',
                    subtitle: 'أدخل الرمز المرسل إلى ${widget.phoneNumber}',
                  ),
                  SizedBox(height: 36.h),

                  OtpInputField(
                    length: kOtpLength,
                    controller: _pinController,
                    focusNode: _focusNode,
                    errorText: _errorText,
                    onCompleted: _submit,
                    onChanged: (_) {
                      if (_errorText != null) {
                        setState(() => _errorText = null);
                      }
                    },
                  ),

                  SizedBox(height: 24.h),

                  OtpResendButton(secondsLeft: _secondsLeft, onResend: _resend),

                  SizedBox(height: 16.h),

                  BlocBuilder<OtpCubit, OtpState>(
                    builder: (context, state) {
                      final isLoading = state is OtpLoading;
                      final canSubmit =
                          _pinController.text.length == kOtpLength;
                      return AppButton(
                        label: isLoading ? 'جاري التحقق...' : 'تأكيد',
                        onPressed: (isLoading || !canSubmit)
                            ? null
                            : () => _submit(_pinController.text),
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
