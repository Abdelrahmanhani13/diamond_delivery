import 'package:diamond_customer/core/errors/failures.dart';
import 'package:diamond_customer/core/utils/either.dart';
import '../../data/models/checkout_model.dart';

abstract class CheckoutRepo {
  Future<Either<Failure, CheckoutModel>> getCheckout({
    String? addressId,
    String? paymentMethodId,
  });
}
