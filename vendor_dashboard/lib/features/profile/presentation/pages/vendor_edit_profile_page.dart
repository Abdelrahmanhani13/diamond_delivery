import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_dashboard/features/profile/domain/entities/vendor_profile.dart';
import '../controller/profile_cubit/vendor_profile_cubit.dart';
import '../controller/profile_cubit/vendor_profile_state.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';

class VendorEditProfilePage extends StatefulWidget {
  final VendorProfile profile;
  const VendorEditProfilePage({super.key, required this.profile});

  @override
  State<VendorEditProfilePage> createState() => _VendorEditProfilePageState();
}

class _VendorEditProfilePageState extends State<VendorEditProfilePage> {
  late TextEditingController _storeNameController;
  late TextEditingController _phoneController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  final _formKey = GlobalKey<FormState>();

  File? _newLogo;
  File? _newCover;

  @override
  void initState() {
    super.initState();
    _storeNameController = TextEditingController(
      text: widget.profile.storeName,
    );
    _phoneController = TextEditingController(text: widget.profile.phone);
    _descriptionController = TextEditingController(
      text: widget.profile.description,
    );
    _addressController = TextEditingController(text: widget.profile.address);
  }

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
            'تعديل الملف الشخصي',
            style: VendorTextStyles.headingMedium,
          ),
        ),
        body: BlocConsumer<VendorProfileCubit, VendorProfileState>(
          listener: (context, state) {
            if (state is VendorProfileUpdateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: VendorColors.error,
                ),
              );
            } else if (state is VendorProfileUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تحديث الملف الشخصي بنجاح'),
                  backgroundColor: VendorColors.success,
                ),
              );
              context.pop();
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image upload section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: VendorColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: VendorColors.shadow,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'صور المتجر',
                            style: VendorTextStyles.headingSmall,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _ImageUploadButton(
                                  icon: Icons.image_outlined,
                                  label: 'شعار المتجر',
                                  currentUrl: widget.profile.logoUrl,
                                  onTap: () {
                                    // TODO: Implement ImagePicker
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _ImageUploadButton(
                                  icon: Icons.wallpaper_rounded,
                                  label: 'صورة الغلاف',
                                  currentUrl: widget.profile.coverUrl,
                                  onTap: () {
                                    // TODO: Implement ImagePicker
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Info fields
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: VendorColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: VendorColors.shadow,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'معلومات المتجر',
                            style: VendorTextStyles.headingSmall,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _storeNameController,
                            decoration: const InputDecoration(
                              labelText: 'اسم المتجر',
                              prefixIcon: Icon(Icons.storefront_outlined),
                            ),
                            validator: (v) => v == null || v.isEmpty
                                ? 'يرجى إدخال اسم المتجر'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            textDirection: TextDirection.ltr,
                            decoration: const InputDecoration(
                              labelText: 'رقم الجوال',
                              prefixIcon: Icon(Icons.phone_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'نبذة عن المتجر',
                              prefixIcon: Icon(Icons.info_outline_rounded),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _addressController,
                            decoration: const InputDecoration(
                              labelText: 'العنوان',
                              prefixIcon: Icon(Icons.location_on_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      height: 52,
                      child: (state is VendorProfileUpdating)
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: VendorColors.primary,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<VendorProfileCubit>()
                                      .updateProfile(
                                        storeName: _storeNameController.text
                                            .trim(),
                                        phone: _phoneController.text.trim(),
                                        description: _descriptionController.text
                                            .trim(),
                                        address: _addressController.text.trim(),
                                        logoFile: _newLogo,
                                        coverFile: _newCover,
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
                                'حفظ التعديلات',
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
    _storeNameController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}

class _ImageUploadButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? currentUrl;
  final VoidCallback onTap;

  const _ImageUploadButton({
    required this.icon,
    required this.label,
    this.currentUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: VendorColors.greyLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: VendorColors.border),
          image: currentUrl != null
              ? DecorationImage(
                  image: NetworkImage(currentUrl!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    VendorColors.black.withValues(alpha: 0.3),
                    BlendMode.darken,
                  ),
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: currentUrl != null
                  ? VendorColors.white
                  : VendorColors.grey,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: VendorTextStyles.caption.copyWith(
                color: currentUrl != null
                    ? VendorColors.white
                    : VendorColors.textHint,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
