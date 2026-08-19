import 'package:diamond_customer/features/addresses/domain/entities/address_domain_entity.dart';
import 'package:diamond_customer/features/addresses/domain/repos/address_repo_contract.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';

class AddAddressUseCase {
  final AddressRepository _repository;

  AddAddressUseCase(this._repository);

  Future<Either<Failure, Address>> call(Address address) =>
      _repository.addAddress(address);
}
