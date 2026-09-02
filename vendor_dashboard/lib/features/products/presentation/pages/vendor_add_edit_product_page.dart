import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_dashboard/features/products/presentation/controller/vendor_product_form_cubit/vendor_product_form_cubit.dart';
import 'package:vendor_dashboard/features/products/presentation/controller/vendor_product_form_cubit/vendor_product_form_state.dart';
import '../../../../core/theme/vendor_colors.dart';
import '../../../../core/theme/vendor_text_styles.dart';
import '../../../../core/utils/localized_entity_extension.dart';
import '../../domain/entities/vendor_product.dart';
import '../widgets/product_basic_info_section.dart';
import '../widgets/product_image_gallery_section.dart';
import '../widgets/product_pricing_inventory_section.dart';

class VendorAddEditProductPage extends StatefulWidget {
  final VendorProduct? product;
  const VendorAddEditProductPage({super.key, this.product});

  @override
  State<VendorAddEditProductPage> createState() =>
      _VendorAddEditProductPageState();
}

class _VendorAddEditProductPageState extends State<VendorAddEditProductPage> {
  late TextEditingController _subCategoryIdController;
  late TextEditingController _nameArabicController;
  late TextEditingController _nameEnglishController;
  late TextEditingController _descriptionArabicController;
  late TextEditingController _descriptionEnglishController;
  late TextEditingController _priceController;

  late TextEditingController _discountPriceController;
  late TextEditingController _stockQuantityController;
  late TextEditingController _skuController;
  late TextEditingController _barcodeController;
  late TextEditingController _weightController;

  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
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

  Future<void> _onAddImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null || widget.product == null) return;

    if (!mounted) return;
    context.read<VendorProductFormCubit>().uploadImage(
      productId: widget.product!.id,
      imageFile: File(pickedFile.path),
    );
  }

  Future<void> _onDeleteImage(VendorProductImage image) async {
    if (widget.product == null) return;
    final cubit = context.read<VendorProductFormCubit>();
    await cubit.deleteImage(productId: widget.product!.id, imageId: image.id);
    setState(() {
      _images.removeWhere((img) => img.id == image.id);
    });
  }

  Future<void> _onSetPrimaryImage(VendorProductImage image) async {
    if (widget.product == null) return;
    final cubit = context.read<VendorProductFormCubit>();
    await cubit.setPrimaryImage(
      productId: widget.product!.id,
      imageId: image.id,
    );
    setState(() {
      _images = _images
          .map(
            (img) => VendorProductImage(
              id: img.id,
              url: img.url,
              isPrimary: img.id == image.id,
            ),
          )
          .toList();
    });
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final price = double.parse(_priceController.text.trim());
    final discountStr = _discountPriceController.text.trim();
    final discountPrice = discountStr.isNotEmpty
        ? double.tryParse(discountStr)
        : null;
    final stock = int.tryParse(_stockQuantityController.text.trim()) ?? 0;
    final weightStr = _weightController.text.trim();
    final weight = weightStr.isNotEmpty ? double.tryParse(weightStr) : null;

    final cubit = context.read<VendorProductFormCubit>();
    if (isEditing) {
      cubit.updateProduct(
        id: widget.product!.id,
        subCategoryId: _subCategoryIdController.text.trim(),
        nameArabic: _nameArabicController.text.trim(),
        nameEnglish: _nameEnglishController.text.trim(),
        descriptionArabic: _descriptionArabicController.text.trim().isNotEmpty
            ? _descriptionArabicController.text.trim()
            : null,
        descriptionEnglish: _descriptionEnglishController.text.trim().isNotEmpty
            ? _descriptionEnglishController.text.trim()
            : null,
        price: price,
        discountPrice: discountPrice,
        stockQuantity: stock,
        sku: _skuController.text.trim().isNotEmpty
            ? _skuController.text.trim()
            : null,
        barcode: _barcodeController.text.trim().isNotEmpty
            ? _barcodeController.text.trim()
            : null,
        weight: weight,
      );
    } else {
      cubit.createProduct(
        subCategoryId: _subCategoryIdController.text.trim(),
        nameArabic: _nameArabicController.text.trim(),
        nameEnglish: _nameEnglishController.text.trim(),
        descriptionArabic: _descriptionArabicController.text.trim().isNotEmpty
            ? _descriptionArabicController.text.trim()
            : null,
        descriptionEnglish: _descriptionEnglishController.text.trim().isNotEmpty
            ? _descriptionEnglishController.text.trim()
            : null,
        price: price,
        discountPrice: discountPrice,
        stockQuantity: stock,
        sku: _skuController.text.trim().isNotEmpty
            ? _skuController.text.trim()
            : null,
        barcode: _barcodeController.text.trim().isNotEmpty
            ? _barcodeController.text.trim()
            : null,
        weight: weight,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VendorColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: VendorColors.surface,
        elevation: 0,
        title: Text(
          isEditing ? context.tr('editProduct') : context.tr('addNewProduct'),
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
                      ? context.tr('productUpdatedSuccess')
                      : context.tr('productAddedSuccess'),
                ),
                backgroundColor: VendorColors.success,
              ),
            );
            context.pop();
          } else if (state is VendorProductImageUploaded) {
            setState(() => _images = [..._images, state.image]);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr('imageUploadedSuccess')),
                backgroundColor: VendorColors.success,
              ),
            );
          } else if (state is VendorProductImageDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr('imageDeletedSuccess')),
                backgroundColor: VendorColors.success,
              ),
            );
          } else if (state is VendorProductPrimaryImageSet) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr('primarySetSuccess')),
                backgroundColor: VendorColors.success,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is VendorProductFormSubmitting;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProductBasicInfoSection(
                    subCategoryIdController: _subCategoryIdController,
                    nameArabicController: _nameArabicController,
                    nameEnglishController: _nameEnglishController,
                    descriptionArabicController: _descriptionArabicController,
                    descriptionEnglishController: _descriptionEnglishController,
                    priceController: _priceController,
                  ),
                  const SizedBox(height: 16),
                  ProductPricingInventorySection(
                    discountPriceController: _discountPriceController,
                    stockQuantityController: _stockQuantityController,
                    skuController: _skuController,
                    barcodeController: _barcodeController,
                    weightController: _weightController,
                  ),
                  if (isEditing) ...[
                    const SizedBox(height: 16),
                    ProductImageGallerySection(
                      images: _images,
                      isUploading: state is VendorProductImageUploading,
                      onAddImage: _onAddImage,
                      onSetPrimary: _onSetPrimaryImage,
                      onDeleteImage: _onDeleteImage,
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _onSave,
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
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              isEditing
                                  ? context.tr('saveChanges')
                                  : context.tr('addNewProduct'),
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
    );
  }
}
