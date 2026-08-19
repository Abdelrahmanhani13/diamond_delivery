import 'package:vendor_dashboard/features/addresses/domain/entities/address_domain_entity.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../repos/address_repo_contract.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';

class UpdateAddressUseCase {
  final AddressRepository _repository;

  UpdateAddressUseCase(this._repository);

  Future<Either<Failure, Address>> call(Address address) =>
      _repository.updateAddress(address);
}
