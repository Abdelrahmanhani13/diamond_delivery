import 'package:diamond_customer/core/errors/exceptions.dart';
import 'package:diamond_customer/core/errors/failures.dart';
import 'package:diamond_customer/core/network/network_info.dart';
import 'package:diamond_customer/core/utils/either.dart';
import '../../domain/repos/checkout_repo.dart';
import '../datasource/checkout_remote_data_source.dart';
import '../models/checkout_model.dart';

class CheckoutRepoImpl implements CheckoutRepo {
  final CheckoutRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CheckoutRepoImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CheckoutModel>> getCheckout({
    String? addressId,
    String? paymentMethodId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCheckout(
          addressId: addressId,
          paymentMethodId: paymentMethodId,
        );
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, errors: e.errors));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
