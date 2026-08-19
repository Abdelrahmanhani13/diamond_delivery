import 'package:vendor_dashboard/features/auth/data/datasources/vendor_auth_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';

import '../controller/auth_cubit/vendor_auth_cubit.dart';
import '../controller/login_cubit/vendor_login_cubit.dart';
import '../controller/login_cubit/vendor_login_state.dart';

class VendorLoginPage extends StatefulWidget {
  const VendorLoginPage({super.key});

  @override
  State<VendorLoginPage> createState() => _VendorLoginPageState();
}

class _VendorLoginPageState extends State<VendorLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VendorLoginCubit>(
          create: (_) => getIt<VendorLoginCubit>(),
        ),
        BlocProvider<VendorAuthCubit>(create: (_) => getIt<VendorAuthCubit>()),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: VendorColors.scaffoldBackground,
          body: BlocConsumer<VendorLoginCubit, VendorLoginState>(
            listener: (context, state) {
              if (state is VendorLoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: VendorColors.error,
                  ),
                );
              }

              if (state is VendorLoginSuccess) {
                context.read<VendorAuthCubit>().loggedIn();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تسجيل الدخول بنجاح'),
                    backgroundColor: VendorColors.success,
                  ),
                );
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 60),

                        // Logo / Brand
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: VendorColors.primaryGradient,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: VendorColors.primary.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.diamond_rounded,
                                size: 56,
                                color: VendorColors.white,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Diamond Village',
                                style: VendorTextStyles.headingLarge.copyWith(
                                  color: VendorColors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'لوحة تحكم البائع',
                                style: VendorTextStyles.bodyMedium.copyWith(
                                  color: VendorColors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        Text(
                          'تسجيل الدخول',
                          style: VendorTextStyles.headingLarge.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'أدخل بيانات حسابك للوصول إلى لوحة التحكم',
                          style: VendorTextStyles.bodySmall,
                        ),

                        const SizedBox(height: 32),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textDirection: TextDirection.ltr,
                          decoration: const InputDecoration(
                            labelText: 'البريد الإلكتروني',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى إدخال البريد الإلكتروني';
                            }

                            if (!value.contains('@')) {
                              return 'يرجى إدخال بريد إلكتروني صحيح';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textDirection: TextDirection.ltr,
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال كلمة المرور';
                            }

                            if (value.length < 6) {
                              return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        // Forgot password
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              context.push(
                                RoutePaths.resetPassword,
                                extra: _emailController.text.trim(),
                              );
                            },
                            child: Text(
                              'نسيت كلمة المرور؟',
                              style: VendorTextStyles.bodySmall.copyWith(
                                color: VendorColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Login Button
                        SizedBox(
                          height: 52,
                          child: state is VendorLoginLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: VendorColors.primary,
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    context.read<VendorLoginCubit>().login(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                      deviceName: 'Vendor Dashboard',
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: VendorColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Text(
                                    'تسجيل الدخول',
                                    style: VendorTextStyles.buttonLarge,
                                  ),
                                ),
                        ),

                        const SizedBox(height: 24),

                        // Register
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ليس لديك حساب؟',
                              style: VendorTextStyles.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                context.push(RoutePaths.register);
                              },
                              child: Text(
                                'سجّل كبائع',
                                style: VendorTextStyles.bodyMedium.copyWith(
                                  color: VendorColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
