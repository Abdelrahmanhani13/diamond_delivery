import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_dashboard/features/products/presentation/controller/vendor_product_form_cubit/vendor_product_form_cubit.dart';
import 'package:vendor_dashboard/features/products/presentation/controller/vendor_product_form_cubit/vendor_product_form_state.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';
import '../../domain/entities/vendor_product.dart';

class VendorAddEditProductPage extends StatefulWidget {
  final VendorProduct? product;
  const VendorAddEditProductPage({super.key, this.product});

  @override
  State<VendorAddEditProductPage> createState() =>
      _VendorAddEditProductPageState();
}

class _VendorAddEditProductPageState extends State<VendorAddEditProductPage> {
  // ==== الحقول المطلوبة فعليًا من الـ API ====
  late TextEditingController _subCategoryIdController;
  late TextEditingController _nameArabicController;
  late TextEditingController _nameEnglishController;
  late TextEditingController _descriptionArabicController;
  late TextEditingController _descriptionEnglishController;
  late TextEditingController _priceController;

  // ==== حقول اختيارية ====
  late TextEditingController _discountPriceController;
  late TextEditingController _stockQuantityController;
  late TextEditingController _skuController;
  late TextEditingController _barcodeController;
  late TextEditingController _weightController;

  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  /// نسخة محلية قابلة للتعديل من صور المنتج، عشان تتحدّث لايف بعد
  /// الرفع/الحذف/تعيين الرئيسية من غير ما نستنى إعادة تحميل الصفحة.
  late List<VendorProductImage> _images;

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final product = widget.product;

    _subCategoryIdController = TextEditingController(
      text: product?.subCategoryId ?? '',
    );
    _nameArabicController = TextEditingController(
      text: product?.nameArabic ?? '',
    );
    _nameEnglishController = TextEditingController(
      text: product?.nameEnglish ?? '',
    );
    _descriptionArabicController = TextEditingController(
      text: product?.descriptionArabic ?? '',
    );
    _descriptionEnglishController = TextEditingController(
      text: product?.descriptionEnglish ?? '',
    );
    _priceController = TextEditingController(
      text: product != null ? product.price.toStringAsFixed(2) : '',
    );
    _discountPriceController = TextEditingController(
      text: product?.discountPrice != null
          ? product!.discountPrice!.toStringAsFixed(2)
          : '',
    );
    _stockQuantityController = TextEditingController(
      text: product != null ? product.stockQuantity.toString() : '0',
    );
    _skuController = TextEditingController(text: product?.sku ?? '');
    _barcodeController = TextEditingController(text: product?.barcode ?? '');
    _weightController = TextEditingController(
      text: product?.weight != null ? product!.weight!.toString() : '',
    );

    _images = List.of(product?.images ?? const []);
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
            isEditing ? 'تعديل المنتج' : 'إضافة منتج جديد',
            style: VendorTextStyles.headingMedium,
          ),
        ),
        body: BlocConsumer<VendorProductFormCubit, VendorProductFormState>(
          listener: (context, state) {
            if (state is VendorProductFormError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: VendorColors.error,
                ),
              );
            } else if (state is VendorProductFormSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isEditing
                        ? 'تم تحديث المنتج بنجاح'
                        : 'تم إضافة المنتج بنجاح',
                  ),
                  backgroundColor: VendorColors.success,
                ),
              );
              context.pop();
            } else if (state is VendorProductImageUploaded) {
              setState(() => _images = [..._images, state.image]);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم رفع الصورة بنجاح'),
                  backgroundColor: VendorColors.success,
                ),
              );
            } else if (state is VendorProductImageDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف الصورة بنجاح'),
                  backgroundColor: VendorColors.success,
                ),
              );
            } else if (state is VendorProductPrimaryImageSet) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تعيين الصورة الرئيسية'),
                  backgroundColor: VendorColors.success,
                ),
              );
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
                    _sectionCard(
                      title: 'معلومات المنتج الأساسية',
                      children: [
                        TextFormField(
                          controller: _subCategoryIdController,
                          decoration: const InputDecoration(
                            labelText: 'رقم القسم الفرعي (subCategoryId)',
                            prefixIcon: Icon(Icons.category_outlined),
                            // TODO: استبدال الحقل ده بـ Dropdown حقيقي لما
                            // تبعتلي endpoint الـ subcategories.
                            helperText:
                                'مؤقتًا: الصق الـ GUID لحد ما نعمل قايمة اختيار',
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'يرجى إدخال رقم القسم الفرعي'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameArabicController,
                          decoration: const InputDecoration(
                            labelText: 'اسم المنتج (عربي)',
                            prefixIcon: Icon(Icons.diamond_outlined),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'يرجى إدخال اسم المنتج بالعربي'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameEnglishController,
                          decoration: const InputDecoration(
                            labelText: 'اسم المنتج (إنجليزي)',
                            prefixIcon: Icon(Icons.diamond_outlined),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'يرجى إدخال اسم المنتج بالإنجليزي'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionArabicController,
                          decoration: const InputDecoration(
                            labelText: 'وصف المنتج (عربي)',
                            prefixIcon: Icon(Icons.description_outlined),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionEnglishController,
                          decoration: const InputDecoration(
                            labelText: 'وصف المنتج (إنجليزي)',
                            prefixIcon: Icon(Icons.description_outlined),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'السعر',
                            prefixIcon: Icon(Icons.attach_money_rounded),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'يرجى إدخال السعر';
                            }
                            if (double.tryParse(v.trim()) == null) {
                              return 'يرجى إدخال رقم صحيح';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _sectionCard(
                      title: 'تفاصيل إضافية (اختياري)',
                      children: [
                        TextFormField(
                          controller: _discountPriceController,
                          decoration: const InputDecoration(
                            labelText: 'سعر الخصم',
                            prefixIcon: Icon(Icons.discount_outlined),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _stockQuantityController,
                          decoration: const InputDecoration(
                            labelText: 'الكمية المتاحة',
                            prefixIcon: Icon(Icons.inventory_2_outlined),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _skuController,
                          decoration: const InputDecoration(
                            labelText: 'SKU',
                            prefixIcon: Icon(Icons.qr_code_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _barcodeController,
                          decoration: const InputDecoration(
                            labelText: 'الباركود',
                            prefixIcon: Icon(Icons.barcode_reader),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _weightController,
                          decoration: const InputDecoration(
                            labelText: 'الوزن',
                            prefixIcon: Icon(Icons.scale_outlined),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Image Management Section (only for editing)
                    if (isEditing)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: VendorColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: VendorColors.shadow,
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'صور المنتج',
                                  style: VendorTextStyles.headingSmall,
                                ),
                                OutlinedButton.icon(
                                  onPressed:
                                      state is VendorProductImageUploading
                                      ? null
                                      : _onAddImage,
                                  icon: const Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 18,
                                  ),
                                  label: const Text('إضافة صورة'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (state is VendorProductImageUploading)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: VendorColors.primary,
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            else if (_images.isEmpty)
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: VendorColors.greyLight,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: VendorColors.border,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.image_outlined,
                                        size: 40,
                                        color: VendorColors.grey,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'لا توجد صور',
                                        style: VendorTextStyles.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              SizedBox(
                                height: 120,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _images.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    final image = _images[index];
                                    return Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          child: Image.network(
                                            image.url,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, _, _) =>
                                                Container(
                                                  width: 120,
                                                  height: 120,
                                                  color: VendorColors.greyLight,
                                                  child: const Icon(
                                                    Icons.broken_image_outlined,
                                                  ),
                                                ),
                                          ),
                                        ),
                                        if (image.isPrimary)
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: VendorColors.primary,
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                              child: Text(
                                                'رئيسية',
                                                style: VendorTextStyles.caption
                                                    .copyWith(
                                                      color: VendorColors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        Positioned(
                                          bottom: 4,
                                          left: 4,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (!image.isPrimary)
                                                _ImageActionButton(
                                                  icon: Icons
                                                      .star_outline_rounded,
                                                  color: VendorColors.accent,
                                                  onTap: () =>
                                                      _onSetPrimaryImage(image),
                                                ),
                                              const SizedBox(width: 4),
                                              _ImageActionButton(
                                                icon: Icons
                                                    .delete_outline_rounded,
                                                color: VendorColors.error,
                                                onTap: () =>
                                                    _onDeleteImage(image),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      height: 52,
                      child: state is VendorProductFormLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: VendorColors.primary,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _onSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: VendorColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                isEditing ? 'حفظ التعديلات' : 'إضافة المنتج',
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

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: VendorColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: VendorColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: VendorTextStyles.headingSmall),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Future<void> _onAddImage() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    context.read<VendorProductFormCubit>().uploadImage(
      widget.product!.id,
      File(picked.path),
    );
  }

  void _onDeleteImage(VendorProductImage image) {
    setState(() => _images = _images.where((i) => i.id != image.id).toList());
    context.read<VendorProductFormCubit>().deleteImage(
      widget.product!.id,
      image.id,
    );
  }

  void _onSetPrimaryImage(VendorProductImage image) {
    setState(() {
      _images = _images
          .map(
            (i) => i.id == image.id
                ? VendorProductImage(
                    id: i.id,
                    url: i.url,
                    isPrimary: true,
                    displayOrder: i.displayOrder,
                    createdAt: i.createdAt,
                  )
                : VendorProductImage(
                    id: i.id,
                    url: i.url,
                    isPrimary: false,
                    displayOrder: i.displayOrder,
                    createdAt: i.createdAt,
                  ),
          )
          .toList();
    });
    context.read<VendorProductFormCubit>().setPrimaryImage(
      widget.product!.id,
      image.id,
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<VendorProductFormCubit>();
    final subCategoryId = _subCategoryIdController.text.trim();
    final nameArabic = _nameArabicController.text.trim();
    final nameEnglish = _nameEnglishController.text.trim();
    final descriptionArabic = _descriptionArabicController.text.trim();
    final descriptionEnglish = _descriptionEnglishController.text.trim();
    final price = double.parse(_priceController.text.trim());
    final discountPrice = double.tryParse(_discountPriceController.text.trim());
    final stockQuantity =
        int.tryParse(_stockQuantityController.text.trim()) ?? 0;
    final sku = _skuController.text.trim();
    final barcode = _barcodeController.text.trim();
    final weight = double.tryParse(_weightController.text.trim());

    if (isEditing) {
      cubit.updateProduct(
        id: widget.product!.id,
        subCategoryId: subCategoryId,
        nameArabic: nameArabic,
        nameEnglish: nameEnglish,
        descriptionArabic: descriptionArabic.isEmpty ? null : descriptionArabic,
        descriptionEnglish: descriptionEnglish.isEmpty
            ? null
            : descriptionEnglish,
        price: price,
        discountPrice: discountPrice,
        stockQuantity: stockQuantity,
        sku: sku.isEmpty ? null : sku,
        barcode: barcode.isEmpty ? null : barcode,
        weight: weight,
      );
    } else {
      cubit.addProduct(
        subCategoryId: subCategoryId,
        nameArabic: nameArabic,
        nameEnglish: nameEnglish,
        descriptionArabic: descriptionArabic.isEmpty ? null : descriptionArabic,
        descriptionEnglish: descriptionEnglish.isEmpty
            ? null
            : descriptionEnglish,
        price: price,
        discountPrice: discountPrice,
        stockQuantity: stockQuantity,
        sku: sku.isEmpty ? null : sku,
        barcode: barcode.isEmpty ? null : barcode,
        weight: weight,
      );
    }
  }

  @override
  void dispose() {
    _subCategoryIdController.dispose();
    _nameArabicController.dispose();
    _nameEnglishController.dispose();
    _descriptionArabicController.dispose();
    _descriptionEnglishController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
    _stockQuantityController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}

class _ImageActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ImageActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: VendorColors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
