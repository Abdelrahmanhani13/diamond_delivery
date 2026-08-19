import 'package:vendor_dashboard/features/addresses/domain/entities/coordinates_value_entity.dart';
import 'package:vendor_dashboard/features/addresses/domain/repos/location_repo_contract.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';

class GetCurrentLocationUseCase {
  final LocationRepository _repository;

  GetCurrentLocationUseCase(this._repository);

  Future<Either<Failure, Coordinates>> call() =>
      _repository.getCurrentLocation();
}
