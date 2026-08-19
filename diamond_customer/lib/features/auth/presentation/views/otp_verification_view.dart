import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/app_button.dart';
import '../controller/cubits/otp/otp_cubit.dart';
import '../controller/cubits/otp/otp_state.dart';
import '../widgets/auth_header.dart';
import 'widgets/otp_input_field.dart';
import 'widgets/otp_resend_button.dart';

const int kOtpLength = 6;
const int _resendCooldownSeconds = 180;

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

  Timer? _timer;
  int _secondsLeft = _resendCooldownSeconds;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendCooldownSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _submit(String code) {
    if (code.length != kOtpLength) return;

    final otpType = widget.isPasswordReset ? 'ResetPassword' : 'Registration';
    context.read<OtpCubit>().verifyOtp(widget.phoneNumber, code, otpType);
  }

  void _resend() {
    if (_secondsLeft > 0) return;
    context.read<OtpCubit>().requestOtp(
          widget.phoneNumber,
          widget.isPasswordReset ? 'ResetPassword' : 'Registration',
        );
    _startCooldown();
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
            if (state is OtpSuccess) {
              if (widget.isPasswordReset) {
                context.push(
                  AppRoutes.resetPassword,
                  extra: {
                    'phoneNumber': widget.phoneNumber,
                    'otp': _pinController.text
                  },
                );
              } else {
                context.go(AppRoutes.home);
              }
            } else if (state is OtpResentSuccess) {
              AppToast.success(
                context,
                message: context.tr('resendCode'),
                title: context.tr('resendCode'),
              );
            } else if (state is OtpError) {
              setState(() => _errorText = state.message);
              _pinController.clear();
              _focusNode.requestFocus();
              ScaffoldMessenger.of(context).clearSnackBars();
              AppToast.error(
                context,
                message: state.message,
              );
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeader(
                  title: context.tr('verifyPhoneTitle'),
                  subtitle: '${context.tr('verifyPhoneSubtitle')} ${widget.phoneNumber}',
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
                OtpResendButton(
                  secondsLeft: _secondsLeft,
                  onResend: _resend,
                ),
                SizedBox(height: 16.h),
                BlocBuilder<OtpCubit, OtpState>(
                  builder: (context, state) {
                    final isLoading = state is OtpLoading;
                    final canSubmit =
                        _pinController.text.length == kOtpLength;
                    return AppButton(
                      label: isLoading ? context.tr('loading') : context.tr('verifyOtp'),
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
    );
  }
}
