import 'package:diamond_customer/core/api/api_client.dart';
import 'package:diamond_customer/core/api/api_constants.dart';
import '../models/checkout_model.dart';

abstract class CheckoutRemoteDataSource {
  Future<CheckoutModel> getCheckout({
    String? addressId,
    String? paymentMethodId,
  });
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final ApiClient apiClient;

  CheckoutRemoteDataSourceImpl(this.apiClient);

  @override
  Future<CheckoutModel> getCheckout({
    String? addressId,
    String? paymentMethodId,
  }) async {
    final Map<String, dynamic> queryParameters = {};
    if (addressId != null && addressId.isNotEmpty) {
      queryParameters['addressId'] = addressId;
    }
    if (paymentMethodId != null && paymentMethodId.isNotEmpty) {
      queryParameters['paymentMethodId'] = paymentMethodId;
    }

    final response = await apiClient.get(
      ApiConstants.checkout,
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );

    final data = response['data'] as Map<String, dynamic>;
    return CheckoutModel.fromJson(data);
  }
}
