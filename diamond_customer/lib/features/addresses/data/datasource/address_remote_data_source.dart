import '../models/address_model.dart';
import 'package:diamond_customer/core/api/api_client.dart';
import 'package:diamond_customer/core/api/api_constants.dart';

abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> getAddressById(String id);
  Future<AddressModel> addAddress(AddressModel address);
  Future<AddressModel> updateAddress(AddressModel address);
  Future<void> deleteAddress(String id);
  Future<void> setDefaultAddress(String id);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final ApiClient _apiClient;

  AddressRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<AddressModel>> getAddresses() async {
    final response = await _apiClient.get(ApiConstants.address);
    final data = response['data'] as List? ?? [];
    return data
        .map((json) => AddressModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AddressModel> getAddressById(String id) async {
    final response = await _apiClient.get('${ApiConstants.address}/$id');
    return AddressModel.fromJson(response['data']);
  }

  @override
  Future<AddressModel> addAddress(AddressModel address) async {
    final response = await _apiClient.post(
      ApiConstants.address,
      data: address.toJson(),
    );
    return AddressModel.fromJson(response['data']);
  }

  @override
  Future<AddressModel> updateAddress(AddressModel address) async {
    final response = await _apiClient.put(
      '${ApiConstants.address}/${address.id}',
      data: address.toJson(),
    );
    return AddressModel.fromJson(response['data']);
  }

  @override
  Future<void> deleteAddress(String id) async {
    await _apiClient.delete('${ApiConstants.address}/$id');
  }

  @override
  Future<void> setDefaultAddress(String id) async {
    await _apiClient.patch(
      ApiConstants.setDefaultAddress(id),
    );
  }
}
