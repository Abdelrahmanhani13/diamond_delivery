// domain/usecases/get_vendor_product_by_id_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vendor_product.dart';
import '../repositories/vendor_product_repository.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';

class GetVendorProductByIdUseCase {
  final VendorProductRepository repository;
  GetVendorProductByIdUseCase(this.repository);

  Future<Either<Failure, VendorProduct>> call(String id) {
    return repository.getProductById(id);
  }
}
