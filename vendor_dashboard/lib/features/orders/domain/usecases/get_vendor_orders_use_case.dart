import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../repositories/vendor_orders_repository.dart';
import '../../data/models/paginated_orders_model.dart';

class GetVendorOrdersUseCase {
  final VendorOrdersRepository repository;

  GetVendorOrdersUseCase(this.repository);

  Future<Either<Failure, PaginatedOrdersModel>> call({
    required int page,
    required int pageSize,
    String? status,
  }) {
    return repository.getOrders(page: page, pageSize: pageSize, status: status);
  }
}
