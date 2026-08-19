import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../controller/reset_password_cubit/vendor_reset_password_cubit.dart';
import '../controller/reset_password_cubit/vendor_reset_password_state.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';

class VendorResetPasswordPage extends StatefulWidget {
  final String email;

  const VendorResetPasswordPage({super.key, required this.email});

  @override
  State<VendorResetPasswordPage> createState() =>
      _VendorResetPasswordPageState();
}

class _VendorResetPasswordPageState extends State<VendorResetPasswordPage> {
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: VendorColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: VendorColors.surface,
          elevation: 0,
          title: Text(
            'إعادة تعيين كلمة المرور',
            style: VendorTextStyles.headingMedium,
          ),
        ),
        body: BlocConsumer<VendorResetPasswordCubit, VendorResetPasswordState>(
          listener: (context, state) {
            if (state is VendorResetPasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: VendorColors.error,
                ),
              );
            } else if (state is VendorResetPasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إعادة تعيين كلمة المرور بنجاح'),
                  backgroundColor: VendorColors.success,
                ),
              );
              context.pop();
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: VendorColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        size: 56,
                        color: VendorColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'إنشاء كلمة مرور جديدة',
                      style: VendorTextStyles.headingLarge.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'أدخل رمز التحقق وكلمة المرور الجديدة\n${widget.email}',
                      style: VendorTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _otpController,
                      textDirection: TextDirection.ltr,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'رمز التحقق (OTP)',
                        prefixIcon: Icon(Icons.pin_outlined),
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? 'يرجى إدخال رمز التحقق'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: _obscurePassword,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور الجديدة',
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
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'يرجى إدخال كلمة المرور';
                        }
                        if (v.length < 6) {
                          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      textDirection: TextDirection.ltr,
                      decoration: const InputDecoration(
                        labelText: 'تأكيد كلمة المرور',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'يرجى تأكيد كلمة المرور';
                        }
                        if (v != _newPasswordController.text) {
                          return 'كلمتا المرور غير متطابقتين';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 52,
                      child: state is VendorResetPasswordLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: VendorColors.primary,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<VendorResetPasswordCubit>()
                                      .resetPassword(
                                        email: widget.email,
                                        code: _otpController.text.trim(),
                                        newPassword: _newPasswordController.text
                                            .trim(),
                                      );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: VendorColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'إعادة تعيين كلمة المرور',
                                style: VendorTextStyles.buttonLarge,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
