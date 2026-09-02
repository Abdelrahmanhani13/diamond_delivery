import 'package:diamond_customer/features/addresses/data/datasource/address_remote_data_source.dart';

import '../models/address_model.dart';
import '../../domain/entities/address_domain_entity.dart';
import '../../domain/repos/address_repo_contract.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import 'package:diamond_customer/core/errors/exceptions.dart';
import 'package:diamond_customer/core/network/network_info.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  AddressRepositoryImpl({
    required AddressRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  /// Centralized execution + error mapping so every method handles
  /// failures the same way. Order matters: most specific exceptions
  /// first, generic catch last as a true fallback only.
  Future<Either<Failure, T>> _execute<T>(Future<T> Function() action) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await action();
      return Right(result);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
          errors: e.errors,
        ),
      );
    } on NetworkException catch (e) {
      // ioexception
      // Was previously falling through to the generic catch below and
      // losing this message — request started fine but the connection
      // dropped mid-flight (different from the isConnected pre-check above).
      return Left(NetworkFailure(message: e.message));
    } catch (_) {
      // True fallback for anything unforeseen. Deliberately does NOT
      // expose e.toString() to the user — that leaks internal details
      // and often isn't localized.
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<Address>>> getAddresses() {
    return _execute(() => _remoteDataSource.getAddresses());
  }

  @override
  Future<Either<Failure, Address>> getAddressById(String id) {
    return _execute(() => _remoteDataSource.getAddressById(id));
  }

  @override
  Future<Either<Failure, Address>> addAddress(Address address) {
    return _execute(
      () => _remoteDataSource.addAddress(AddressModel.fromEntity(address)),
    );
  }

  @override
  Future<Either<Failure, Address>> updateAddress(Address address) {
    return _execute(
      () => _remoteDataSource.updateAddress(AddressModel.fromEntity(address)),
    );
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String id) {
    return _execute(() => _remoteDataSource.deleteAddress(id));
  }

  @override
  Future<Either<Failure, void>> setDefaultAddress(String id) {
    return _execute(() => _remoteDataSource.setDefaultAddress(id));
  }
}
