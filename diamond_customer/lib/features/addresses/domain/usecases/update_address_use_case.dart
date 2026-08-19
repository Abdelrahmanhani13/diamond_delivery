import 'package:diamond_customer/features/addresses/domain/entities/address_domain_entity.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../repos/address_repo_contract.dart';

class UpdateAddressUseCase {
  final AddressRepository _repository;

  UpdateAddressUseCase(this._repository);

  Future<Either<Failure, Address>> call(Address address) =>
      _repository.updateAddress(address);
}
