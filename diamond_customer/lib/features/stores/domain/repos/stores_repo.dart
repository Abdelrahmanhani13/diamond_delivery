import '../../../../core/utils/either.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vendor.dart';

abstract class StoresRepo {
  Future<Either<Failure, List<Vendor>>> getVendors({
    required int page,
    required int pageSize,
    String? search,
    String? categoryId,
    bool? openNow,
    double? rating,
    String? sortBy, // Nearest, Highest Rated, Newest
  });

  Future<Either<Failure, List<Vendor>>> getNearbyVendors({
    required double latitude,
    required double longitude,
    required double radiusKm,
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, Vendor>> getVendorById(String id);
}
