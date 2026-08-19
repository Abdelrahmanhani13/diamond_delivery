import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/validators.dart';
import '../controller/cubits/login/login_cubit.dart';
import '../controller/cubits/login/login_state.dart';
import 'auth_header.dart';
import '../views/widgets/login_form_card.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: const _LoginForm(),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _submitted = false;

  String? _serverPhoneError;
  String? _serverPasswordError;

  String? get _phoneError =>
      _serverPhoneError ??
      (_submitted ? PhoneValidator.validate(_phoneController.text) : null);

  String? get _passwordError =>
      _serverPasswordError ??
      (_submitted && _passwordController.text.isEmpty
          ? 'يرجى إدخال كلمة المرور'
          : null);

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _submitted = true);
    if (_phoneError != null || _passwordError != null) return;

    context.read<LoginCubit>().login(
      _phoneController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.go(AppRoutes.onboarding),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                context.go(AppRoutes.home);
              } else if (state is LoginError) {
                setState(() {
                  _serverPhoneError = null;
                  _serverPasswordError = null;
                });

                bool hasFieldErrors = false;

                // 1. Check for specific unverified phone error
                if (state.errors?.any((e) => e.code == 'رقم الهاتف غير مؤكد') ??
                    false) {
                  AppToast.warning(
                    context,
                    message: 'برجاء تأكيد رقم الهاتف أولاً للمتابعة.',
                    title: 'تأكيد الهاتف',
                  );
                  context.push(
                    AppRoutes.otpVerification,
                    extra: {'phoneNumber': _phoneController.text.trim()},
                  );
                  return; // Stop here, don't show generic message
                }

                // 2. Map detailed field validation errors to the text fields
                if (state.errors != null && state.errors!.isNotEmpty) {
                  for (final error in state.errors!) {
                    if (error.field == 'PhoneNumber') {
                      setState(() => _serverPhoneError = error.message);
                      hasFieldErrors = true;
                    } else if (error.field == 'Password') {
                      setState(() => _serverPasswordError = error.message);
                      hasFieldErrors = true;
                    }
                  }
                }

                // 3. Fallback to snackbar if the errors couldn't be attached to fields
                if (!hasFieldErrors) {
                  AppToast.error(context, message: state.message);
                }
              }
            },
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthHeader(
                          title: 'تسجيل الدخول',
                          subtitle:
                              'مرحباً بعودتك! سجّل الدخول لمتابعة تسوقك المفضل',
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(
                          begin: -0.15,
                          end: 0,
                          curve: Curves.easeOutCubic,
                        ),

                    Gap(28.h),

                    LoginFormCard(
                      phoneController: _phoneController,
                      passwordController: _passwordController,
                      phoneError: _phoneError,
                      passwordError: _passwordError,
                      obscure: _obscure,
                      onPhoneChanged: (_) {
                        setState(() => _serverPhoneError = null);
                      },
                      onPasswordChanged: (_) {
                        setState(() => _serverPasswordError = null);
                      },
                      onObscureToggle: () {
                        setState(() => _obscure = !_obscure);
                      },
                      onSubmit: _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
