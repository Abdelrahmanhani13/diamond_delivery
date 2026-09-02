import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/vendor_order.dart';
import '../repositories/vendor_orders_repository.dart';

class AcceptVendorOrderUseCase {
  final VendorOrdersRepository repository;

  AcceptVendorOrderUseCase(this.repository);

  Future<Either<Failure, VendorOrder>> call(String id) {
    return repository.acceptOrder(id);
  }
}
