import 'package:diamond_customer/features/addresses/domain/repos/address_repo_contract.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';

class SetDefaultAddressUseCase {
  final AddressRepository _repository;

  SetDefaultAddressUseCase(this._repository);

  Future<Either<Failure, void>> call(String id) =>
      _repository.setDefaultAddress(id);
}
