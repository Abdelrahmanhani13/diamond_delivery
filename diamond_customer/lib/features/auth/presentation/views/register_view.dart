import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/divider_with_label.dart';
import '../controller/cubits/register/register_cubit.dart';
import '../controller/cubits/register/register_state.dart';
import '../widgets/auth_header.dart';
import 'widgets/register_form_card.dart';
import 'widgets/register_terms_text.dart';
import 'widgets/social_auth_buttons_row.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterCubit>(),
      child: const _RegisterForm(),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dobController = TextEditingController();
  bool _obscure = true;
  bool _submitted = false;
  DateTime? _selectedDob;

  String? _serverFirstNameError;
  String? _serverLastNameError;
  String? _serverEmailError;
  String? _serverPhoneError;
  String? _serverPasswordError;

  String? get _firstNameError =>
      _serverFirstNameError ??
      (_submitted && _firstNameController.text.trim().isEmpty
          ? 'يرجى إدخال الاسم الأول'
          : null);

  String? get _lastNameError =>
      _serverLastNameError ??
      (_submitted && _lastNameController.text.trim().isEmpty
          ? 'يرجى إدخال اسم العائلة'
          : null);

  String? get _emailError =>
      _serverEmailError ??
      (_submitted ? EmailValidator.validate(_emailController.text) : null);

  String? get _phoneError =>
      _serverPhoneError ??
      (_submitted ? PhoneValidator.validate(_phoneController.text) : null);

  String? get _passwordError =>
      _serverPasswordError ??
      (_submitted
          ? PasswordValidator.validate(_passwordController.text)
          : null);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1920),
      lastDate: now,
      helpText: 'اختر تاريخ الميلاد',
      cancelText: 'إلغاء',
      confirmText: 'تأكيد',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _submit() {
    setState(() => _submitted = true);
    final hasError = _firstNameError != null ||
        _lastNameError != null ||
        _emailError != null ||
        _phoneError != null ||
        _passwordError != null;
    if (hasError) return;

    context.read<RegisterCubit>().register(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          dateOfBirth:
              _dobController.text.isNotEmpty ? _dobController.text : null,
        );
  }

  void _handleRegisterState(BuildContext context, RegisterState state) {
    if (state is RegisterSuccess) {
      context.push(
        AppRoutes.otpVerification,
        extra: {'phoneNumber': _phoneController.text.trim()},
      );
    } else if (state is RegisterError) {
      setState(() {
        _serverFirstNameError = null;
        _serverLastNameError = null;
        _serverPhoneError = null;
        _serverEmailError = null;
        _serverPasswordError = null;
      });

      bool hasFieldErrors = false;
      if (state.errors != null && state.errors!.isNotEmpty) {
        for (final error in state.errors!) {
          if (error.field == 'FirstName') {
            setState(() => _serverFirstNameError = error.message);
            hasFieldErrors = true;
          } else if (error.field == 'LastName') {
            setState(() => _serverLastNameError = error.message);
            hasFieldErrors = true;
          } else if (error.field == 'PhoneNumber') {
            setState(() => _serverPhoneError = error.message);
            hasFieldErrors = true;
          } else if (error.field == 'Email') {
            setState(() => _serverEmailError = error.message);
            hasFieldErrors = true;
          } else if (error.field == 'Password') {
            setState(() => _serverPasswordError = error.message);
            hasFieldErrors = true;
          }
        }
      }

      if (!hasFieldErrors) {
        AppToast.error(context, message: state.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocListener<RegisterCubit, RegisterState>(
          listener: _handleRegisterState,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthHeader(
                    title: context.tr('register'),
                    subtitle: context.tr('registerSubtitle'),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(
                        begin: -0.15,
                        end: 0,
                        curve: Curves.easeOutCubic,
                      ),

                  Gap(28.h),

                  RegisterFormCard(
                    firstNameController: _firstNameController,
                    lastNameController: _lastNameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    passwordController: _passwordController,
                    dobController: _dobController,
                    obscurePassword: _obscure,
                    onToggleObscure: () =>
                        setState(() => _obscure = !_obscure),
                    onPickDateOfBirth: _pickDateOfBirth,
                    firstNameError: _firstNameError,
                    lastNameError: _lastNameError,
                    emailError: _emailError,
                    phoneError: _phoneError,
                    passwordError: _passwordError,
                    onFirstNameChanged: (_) =>
                        setState(() => _serverFirstNameError = null),
                    onLastNameChanged: (_) =>
                        setState(() => _serverLastNameError = null),
                    onEmailChanged: (_) =>
                        setState(() => _serverEmailError = null),
                    onPhoneChanged: (_) =>
                        setState(() => _serverPhoneError = null),
                    onPasswordChanged: (_) =>
                        setState(() => _serverPasswordError = null),
                    submitButton: BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) {
                        final isLoading = state is RegisterLoading;
                        return AppButton(
                          label: isLoading
                              ? context.tr('loading')
                              : context.tr('confirm'),
                          onPressed: isLoading ? null : _submit,
                        );
                      },
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .slideY(
                        begin: 0.1,
                        end: 0,
                        curve: Curves.easeOutCubic,
                      ),

                  Gap(20.h),

                  const RegisterTermsText().animate().fadeIn(delay: 300.ms),

                  Gap(20.h),

                  const DividerWithLabel(label: 'أو تابع باستخدام'),

                  Gap(16.h),

                  SocialAuthButtonsRow(
                    onGooglePressed: () => context.go(AppRoutes.home),
                    onFacebookPressed: () => context.go(AppRoutes.home),
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
