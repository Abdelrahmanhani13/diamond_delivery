import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_dashboard/features/addresses/domain/entities/geocoded_address_entity_representing_a_reverse_forward_geocoding_result.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';

import '../controller/register_cubit/vendor_register_cubit.dart';
import '../controller/register_cubit/vendor_register_state.dart';
import '../widgets/register_header_card.dart';
import '../widgets/register_location_picker_tile.dart';

class VendorRegisterPage extends StatefulWidget {
  const VendorRegisterPage({super.key});

  @override
  State<VendorRegisterPage> createState() => _VendorRegisterPageState();
}

class _VendorRegisterPageState extends State<VendorRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameArabicController = TextEditingController();
  final _nameEnglishController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionArabicController = TextEditingController();
  final _descriptionEnglishController = TextEditingController();

  final _deliveryFeeController = TextEditingController(text: '0');
  final _minimumOrderController = TextEditingController(text: '0');
  final _vendorCategoryIdController = TextEditingController();

  double? _selectedLat;
  double? _selectedLng;

  @override
  void dispose() {
    _nameArabicController.dispose();
    _nameEnglishController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _descriptionArabicController.dispose();
    _descriptionEnglishController.dispose();
    _deliveryFeeController.dispose();
    _minimumOrderController.dispose();
    _vendorCategoryIdController.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
    final result = await context.push<GeocodedAddress>('/location-picker');

    if (result == null || !mounted) return;

    setState(() {
      _selectedLat = result.latitude;
      _selectedLng = result.longitude;

      _addressController.text = result.displayName.isNotEmpty
          ? result.displayName
          : [
              result.street,
              result.area,
              result.city,
            ].where((e) => e.trim().isNotEmpty).join('، ');
    });
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedLat == null || _selectedLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى تحديد موقع المتجر على الخريطة أولاً'),
          backgroundColor: VendorColors.error,
        ),
      );
      return;
    }

    final deliveryFee =
        double.tryParse(_deliveryFeeController.text.trim()) ?? 0;
    final minimumOrder =
        double.tryParse(_minimumOrderController.text.trim()) ?? 0;

    context.read<VendorRegisterCubit>().register(
      vendorCategoryId: _vendorCategoryIdController.text.trim(),
      nameArabic: _nameArabicController.text.trim(),
      nameEnglish: _nameEnglishController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      latitude: _selectedLat!,
      longitude: _selectedLng!,
      descriptionArabic: _descriptionArabicController.text.trim().isNotEmpty
          ? _descriptionArabicController.text.trim()
          : null,
      descriptionEnglish: _descriptionEnglishController.text.trim().isNotEmpty
          ? _descriptionEnglishController.text.trim()
          : null,
      whatsappNumber: _whatsappController.text.trim().isNotEmpty
          ? _whatsappController.text.trim()
          : null,
      email: _emailController.text.trim().isNotEmpty
          ? _emailController.text.trim()
          : null,
      deliveryFee: deliveryFee,
      minimumOrder: minimumOrder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VendorRegisterCubit>(
      create: (_) => getIt<VendorRegisterCubit>(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: VendorColors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: VendorColors.surface,
            elevation: 0,
            title: Text(
              'تسجيل بائع جديد',
              style: VendorTextStyles.headingMedium,
            ),
          ),
          body: BlocConsumer<VendorRegisterCubit, VendorRegisterState>(
            listener: (context, state) {
              if (state is VendorRegisterFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: VendorColors.error,
                  ),
                );
              } else if (state is VendorRegisterSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تسجيل المتجر بنجاح'),
                    backgroundColor: VendorColors.success,
                  ),
                );

                context.pop();
              }
            },
            builder: (context, state) {
              final isLoading = state is VendorRegisterLoading;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const RegisterHeaderCard(),
                      const SizedBox(height: 24),
                      RegisterLocationPickerTile(
                        latitude: _selectedLat,
                        longitude: _selectedLng,
                        addressText: _addressController.text,
                        onTap: _pickLocation,
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: _addressController,
                        label: 'العنوان الظاهر',
                        icon: Icons.home_work_outlined,
                        required: true,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: _nameArabicController,
                        label: 'اسم المتجر (عربي)',
                        icon: Icons.storefront_outlined,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: _nameEnglishController,
                        label: 'اسم المتجر (إنجليزي)',
                        icon: Icons.storefront_outlined,
                        required: true,
                        textDirection: TextDirection.ltr,
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: _phoneController,
                        label: 'رقم الجوال',
                        icon: Icons.phone_outlined,
                        required: true,
                        keyboardType: TextInputType.phone,
                        textDirection: TextDirection.ltr,
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: _vendorCategoryIdController,
                        label: 'معرّف فئة المتجر (GUID)',
                        icon: Icons.category_outlined,
                        required: true,
                        textDirection: TextDirection.ltr,
                        helperText: 'مؤقتًا: أدخل GUID الفئة',
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: _whatsappController,
                        label: 'رقم الواتساب (اختياري)',
                        icon: Icons.chat_outlined,
                        keyboardType: TextInputType.phone,
                        textDirection: TextDirection.ltr,
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: _emailController,
                        label: 'البريد الإلكتروني (اختياري)',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textDirection: TextDirection.ltr,
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: _descriptionArabicController,
                        label: 'وصف المتجر (عربي - اختياري)',
                        icon: Icons.description_outlined,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: _descriptionEnglishController,
                        label: 'وصف المتجر (إنجليزي - اختياري)',
                        icon: Icons.description_outlined,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              controller: _deliveryFeeController,
                              label: 'رسوم التوصيل (د.أ)',
                              icon: Icons.local_shipping_outlined,
                              required: true,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildField(
                              controller: _minimumOrderController,
                              label: 'الحد الأدنى (د.أ)',
                              icon: Icons.shopping_bag_outlined,
                              required: true,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : () => _submit(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: VendorColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: VendorColors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'تأكيد وإنشاء المتجر',
                                  style: VendorTextStyles.buttonLarge,
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    TextDirection? textDirection,
    int maxLines = 1,
    String? helperText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textDirection: textDirection,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        helperText: helperText,
      ),
      validator: (value) {
        if (!required) return null;
        if (value == null || value.trim().isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }
}
