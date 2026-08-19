import 'package:vendor_dashboard/features/addresses/domain/repos/address_repo_contract.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';

class DeleteAddressUseCase {
  final AddressRepository _repository;

  DeleteAddressUseCase(this._repository);

  Future<Either<Failure, void>> call(String id) =>
      _repository.deleteAddress(id);
}
