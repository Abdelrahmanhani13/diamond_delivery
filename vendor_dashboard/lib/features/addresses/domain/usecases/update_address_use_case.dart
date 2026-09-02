import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/address_domain_entity.dart';
import '../repos/address_repo_contract.dart';

class UpdateAddressUseCase {
  final AddressRepository _repository;

  UpdateAddressUseCase(this._repository);

  Future<Either<Failure, Address>> call(Address address) async {
    return await _repository.updateAddress(address);
  }
}
