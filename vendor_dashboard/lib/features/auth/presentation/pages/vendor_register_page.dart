import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_dashboard/features/addresses/domain/entities/geocoded_address_entity_representing_a_reverse_forward_geocoding_result.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';

import '../controller/register_cubit/vendor_register_cubit.dart';
import '../controller/register_cubit/vendor_register_state.dart';

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
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ==============================
                      // Header
                      // ==============================
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: VendorColors.primaryLight,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.store_rounded,
                              size: 48,
                              color: VendorColors.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'أنشئ متجرك الآن',
                              style: VendorTextStyles.headingMedium.copyWith(
                                color: VendorColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'أدخل بيانات المتجر وموقعه للبدء في البيع',
                              style: VendorTextStyles.bodySmall.copyWith(
                                color: VendorColors.primaryDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ==============================
                      // Store Location
                      // ==============================
                      Text(
                        'موقع المتجر',
                        style: VendorTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 8),

                      GestureDetector(
                        onTap: _pickLocation,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: VendorColors.primaryLight,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: VendorColors.primary.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                color: VendorColors.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedLat == null
                                      ? 'اضغط لتحديد موقع المتجر على الخريطة'
                                      : (_addressController.text.isNotEmpty
                                            ? _addressController.text
                                            : 'تم تحديد الموقع'),
                                  style: VendorTextStyles.bodyMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.chevron_left),
                            ],
                          ),
                        ),
                      ),

                      if (_selectedLat != null && _selectedLng != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Lat: ${_selectedLat!.toStringAsFixed(5)}  |  '
                          'Lng: ${_selectedLng!.toStringAsFixed(5)}',
                          style: VendorTextStyles.bodySmall,
                          textDirection: TextDirection.ltr,
                        ),
                      ],

                      const SizedBox(height: 16),

                      _buildField(
                        controller: _addressController,
                        label: 'العنوان الظاهر',
                        icon: Icons.home_work_outlined,
                        required: true,
                        maxLines: 2,
                      ),

                      const SizedBox(height: 16),

                      // ==============================
                      // Store Name Arabic
                      // ==============================
                      _buildField(
                        controller: _nameArabicController,
                        label: 'اسم المتجر (عربي)',
                        icon: Icons.storefront_outlined,
                        required: true,
                      ),

                      const SizedBox(height: 16),

                      // ==============================
                      // Store Name English
                      // ==============================
                      _buildField(
                        controller: _nameEnglishController,
                        label: 'اسم المتجر (إنجليزي)',
                        icon: Icons.storefront_outlined,
                        required: true,
                        textDirection: TextDirection.ltr,
                      ),

                      const SizedBox(height: 16),

                      // ==============================
                      // Phone
                      // ==============================
                      _buildField(
                        controller: _phoneController,
                        label: 'رقم الجوال',
                        icon: Icons.phone_outlined,
                        required: true,
                        keyboardType: TextInputType.phone,
                        textDirection: TextDirection.ltr,
                      ),

                      const SizedBox(height: 16),

                      // ==============================
                      // WhatsApp
                      // ==============================
                      _buildField(
                        controller: _whatsappController,
                        label: 'رقم الواتساب (اختياري)',
                        icon: Icons.chat_outlined,
                        keyboardType: TextInputType.phone,
                        textDirection: TextDirection.ltr,
                      ),

                      const SizedBox(height: 16),

                      // ==============================
                      // Email
                      // ==============================
                      _buildField(
                        controller: _emailController,
                        label: 'البريد الإلكتروني (اختياري)',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textDirection: TextDirection.ltr,
                      ),

                      const SizedBox(height: 16),

                      // ==============================
                      // Delivery Fee + Minimum Order
                      // ==============================
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              controller: _deliveryFeeController,
                              label: 'رسوم التوصيل',
                              icon: Icons.local_shipping_outlined,
                              required: true,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildField(
                              controller: _minimumOrderController,
                              label: 'الحد الأدنى للطلب',
                              icon: Icons.shopping_bag_outlined,
                              required: true,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ==============================
                      // Vendor Category
                      // ==============================
                      _buildField(
                        controller: _vendorCategoryIdController,
                        label: 'معرف فئة المتجر (Category Id)',
                        icon: Icons.category_outlined,
                        required: true,
                        textDirection: TextDirection.ltr,
                      ),

                      const SizedBox(height: 16),

                      // ==============================
                      // Arabic Description
                      // ==============================
                      _buildField(
                        controller: _descriptionArabicController,
                        label: 'وصف المتجر (عربي) - اختياري',
                        icon: Icons.description_outlined,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 16),

                      // ==============================
                      // English Description
                      // ==============================
                      _buildField(
                        controller: _descriptionEnglishController,
                        label: 'وصف المتجر (إنجليزي) - اختياري',
                        icon: Icons.description_outlined,
                        maxLines: 3,
                        textDirection: TextDirection.ltr,
                      ),

                      const SizedBox(height: 32),

                      // ==============================
                      // Register Button
                      // ==============================
                      SizedBox(
                        height: 52,
                        child: state is VendorRegisterLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: VendorColors.primary,
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  _submitRegistration(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: VendorColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Text(
                                  'إنشاء المتجر',
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

  // ============================================================
  // Submit Registration
  // ============================================================

  void _submitRegistration(BuildContext context) {
    if (_selectedLat == null || _selectedLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('من فضلك حدد موقع المتجر على الخريطة أولاً'),
          backgroundColor: VendorColors.error,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
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

      descriptionArabic: _descriptionArabicController.text.trim().isEmpty
          ? null
          : _descriptionArabicController.text.trim(),

      descriptionEnglish: _descriptionEnglishController.text.trim().isEmpty
          ? null
          : _descriptionEnglishController.text.trim(),

      whatsappNumber: _whatsappController.text.trim().isEmpty
          ? null
          : _whatsappController.text.trim(),

      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),

      deliveryFee: deliveryFee,

      minimumOrder: minimumOrder,
    );
  }

  // ============================================================
  // Text Field Builder
  // ============================================================

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    TextDirection? textDirection,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textDirection: textDirection,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      validator: required
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return 'هذا الحقل مطلوب';
              }

              return null;
            }
          : null,
    );
  }

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
}
