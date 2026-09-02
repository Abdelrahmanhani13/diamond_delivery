import 'package:dartz/dartz.dart';
import 'package:vendor_dashboard/core/errors/failures.dart';
import 'package:vendor_dashboard/features/addresses/domain/entities/address_domain_entity.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<Address>>> getAddresses();
  Future<Either<Failure, Address>> getAddressById(String id);
  Future<Either<Failure, Address>> addAddress(Address address);
  Future<Either<Failure, Address>> updateAddress(Address address);
  Future<Either<Failure, void>> deleteAddress(String id);
  Future<Either<Failure, void>> setDefaultAddress(String id);
}
