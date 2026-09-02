import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/vendor_product.dart';
import '../repositories/vendor_product_repository.dart';

class CreateVendorProductUseCase {
  final VendorProductRepository repository;

  CreateVendorProductUseCase(this.repository);

  Future<Either<Failure, VendorProduct>> call({
    required String subCategoryId,
    required String nameArabic,
    required String nameEnglish,
    String? descriptionArabic,
    String? descriptionEnglish,
    required double price,
    double? discountPrice,
    int stockQuantity = 0,
    String? sku,
    String? barcode,
    double? weight,
  }) {
    return repository.createProduct(
      subCategoryId: subCategoryId,
      nameArabic: nameArabic,
      nameEnglish: nameEnglish,
      descriptionArabic: descriptionArabic,
      descriptionEnglish: descriptionEnglish,
      price: price,
      discountPrice: discountPrice,
      stockQuantity: stockQuantity,
      sku: sku,
      barcode: barcode,
      weight: weight,
    );
  }
}
