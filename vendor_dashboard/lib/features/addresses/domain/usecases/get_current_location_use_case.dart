import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/coordinates_value_entity.dart';
import '../repos/location_repo_contract.dart';

class GetCurrentLocationUseCase {
  final LocationRepository _repository;

  GetCurrentLocationUseCase(this._repository);

  Future<Either<Failure, Coordinates>> call() async {
    return await _repository.getCurrentLocation();
  }
}
