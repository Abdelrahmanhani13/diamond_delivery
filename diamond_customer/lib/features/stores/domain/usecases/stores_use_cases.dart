import '../../../../core/utils/either.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vendor.dart';
import '../repos/stores_repo.dart';

class GetVendorsUseCase {
  final StoresRepo repo;

  GetVendorsUseCase(this.repo);

  Future<Either<Failure, List<Vendor>>> call({
    required int page,
    required int pageSize,
    String? search,
    String? categoryId,
    bool? openNow,
    double? rating,
    String? sortBy,
  }) async {
    return await repo.getVendors(
      page: page,
      pageSize: pageSize,
      search: search,
      categoryId: categoryId,
      openNow: openNow,
      rating: rating,
      sortBy: sortBy,
    );
  }
}

class GetNearbyVendorsUseCase {
  final StoresRepo repo;

  GetNearbyVendorsUseCase(this.repo);

  Future<Either<Failure, List<Vendor>>> call({
    required double latitude,
    required double longitude,
    required double radiusKm,
    required int page,
    required int pageSize,
  }) async {
    return await repo.getNearbyVendors(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
      page: page,
      pageSize: pageSize,
    );
  }
}

class GetVendorByIdUseCase {
  final StoresRepo repo;

  GetVendorByIdUseCase(this.repo);

  Future<Either<Failure, Vendor>> call(String id) async {
    return await repo.getVendorById(id);
  }
}
