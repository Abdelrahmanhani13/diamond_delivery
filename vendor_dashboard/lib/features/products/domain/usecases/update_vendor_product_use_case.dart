import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/vendor_product.dart';
import '../repositories/vendor_product_repository.dart';

class UpdateVendorProductUseCase {
  final VendorProductRepository repository;

  UpdateVendorProductUseCase(this.repository);

  Future<Either<Failure, VendorProduct>> call({
    required String id,
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
    return repository.updateProduct(
      id: id,
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
