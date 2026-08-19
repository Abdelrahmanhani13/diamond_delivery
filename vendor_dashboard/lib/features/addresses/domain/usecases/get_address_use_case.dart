import 'package:vendor_dashboard/features/addresses/domain/entities/address_domain_entity.dart';
import 'package:vendor_dashboard/features/addresses/domain/repos/address_repo_contract.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';

class GetAddressesUseCase {
  final AddressRepository _repository;

  GetAddressesUseCase(this._repository);

  Future<Either<Failure, List<Address>>> call() => _repository.getAddresses();
}
