import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/otp_cubit/vendor_otp_cubit.dart';
import '../controller/otp_cubit/vendor_otp_state.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';

class VendorOtpPage extends StatefulWidget {
  final String email;
  final String otpType;

  const VendorOtpPage({super.key, required this.email, this.otpType = 'Login'});

  @override
  State<VendorOtpPage> createState() => _VendorOtpPageState();
}

class _VendorOtpPageState extends State<VendorOtpPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: VendorColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: VendorColors.surface,
          elevation: 0,
          title: Text('التحقق من الرمز', style: VendorTextStyles.headingMedium),
        ),
        body: BlocConsumer<VendorOtpCubit, VendorOtpState>(
          listener: (context, state) {
            if (state is VendorOtpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: VendorColors.error,
                ),
              );
            } else if (state is VendorOtpVerifySuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم التحقق بنجاح'),
                  backgroundColor: VendorColors.success,
                ),
              );
            } else if (state is VendorOtpRequestSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إعادة إرسال الرمز'),
                  backgroundColor: VendorColors.success,
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(24),
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
                      Icons.mark_email_read_outlined,
                      size: 56,
                      color: VendorColors.primary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'أدخل رمز التحقق',
                    style: VendorTextStyles.headingLarge.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'تم إرسال رمز التحقق إلى\n${widget.email}',
                    style: VendorTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 46,
                          height: 54,
                          child: TextFormField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: VendorTextStyles.headingMedium,
                            decoration: InputDecoration(
                              counterText: '',
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: VendorColors.border,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: VendorColors.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              }
                              if (value.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 52,
                    child: state is VendorOtpLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: VendorColors.primary,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              if (_otpCode.length == 6) {
                                context.read<VendorOtpCubit>().verifyOtp(
                                  email: widget.email,
                                  code: _otpCode,
                                  otpType: widget.otpType,
                                  deviceName: 'Vendor Dashboard',
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
                              'تأكيد الرمز',
                              style: VendorTextStyles.buttonLarge,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      context.read<VendorOtpCubit>().requestOtp(
                        email: widget.email,
                        otpType: widget.otpType,
                      );
                    },
                    child: Text(
                      'إعادة إرسال الرمز',
                      style: VendorTextStyles.bodyMedium.copyWith(
                        color: VendorColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }
}
