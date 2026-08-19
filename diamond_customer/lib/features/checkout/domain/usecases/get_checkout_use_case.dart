import 'package:diamond_customer/core/errors/failures.dart';
import 'package:diamond_customer/core/utils/either.dart';
import '../../data/models/checkout_model.dart';
import '../repos/checkout_repo.dart';

class GetCheckoutUseCase {
  final CheckoutRepo repo;

  GetCheckoutUseCase(this.repo);

  Future<Either<Failure, CheckoutModel>> call({
    String? addressId,
    String? paymentMethodId,
  }) {
    return repo.getCheckout(
      addressId: addressId,
      paymentMethodId: paymentMethodId,
    );
  }
}
