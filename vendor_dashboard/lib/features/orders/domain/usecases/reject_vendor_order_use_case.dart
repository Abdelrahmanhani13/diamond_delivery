import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/vendor_order.dart';
import '../repositories/vendor_orders_repository.dart';

class RejectVendorOrderUseCase {
  final VendorOrdersRepository repository;

  RejectVendorOrderUseCase(this.repository);

  Future<Either<Failure, VendorOrder>> call({
    required String id,
    required String reason,
  }) {
    return repository.rejectOrder(id: id, reason: reason);
  }
}
