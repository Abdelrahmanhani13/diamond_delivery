import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import '../entities/address_domain_entity.dart';
import '../repos/address_repo_contract.dart';

class GetAddressesUseCase {
  final AddressRepository _repository;

  GetAddressesUseCase(this._repository);

  Future<Either<Failure, List<Address>>> call() async {
    return await _repository.getAddresses();
  }
}
