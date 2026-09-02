import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/vendor_order.dart';
import '../repositories/vendor_orders_repository.dart';

class PreparingVendorOrderUseCase {
  final VendorOrdersRepository repository;

  PreparingVendorOrderUseCase(this.repository);

  Future<Either<Failure, VendorOrder>> call(String id) {
    return repository.preparingOrder(id);
  }
}
