import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../repos/address_repo_contract.dart';

class SetDefaultAddressUseCase {
  final AddressRepository _repository;

  SetDefaultAddressUseCase(this._repository);

  Future<Either<Failure, void>> call(String addressId) async {
    return await _repository.setDefaultAddress(addressId);
  }
}
