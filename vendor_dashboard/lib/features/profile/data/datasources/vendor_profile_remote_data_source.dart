// data/datasources/vendor_profile_remote_data_source.dart
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/api/vendor_api_constants.dart';
import '../models/vendor_profile_model.dart';
import '../models/vendor_update_profile_request_model.dart';
import 'package:vendor_dashboard/core/api/api_client.dart';
import 'package:vendor_dashboard/core/api/vendor_api_constants.dart';

abstract class VendorProfileRemoteDataSource {
  Future<VendorProfileModel> getProfile();
  Future<VendorProfileModel> updateProfile(
    VendorUpdateProfileRequestModel request,
  );
  Future<void> registerVendor(VendorRegisterRequestModel request);
  Future<String> uploadLogo(File file);
  Future<String> uploadCover(File file);
}

class VendorProfileRemoteDataSourceImpl
    implements VendorProfileRemoteDataSource {
  final ApiClient apiClient;

  VendorProfileRemoteDataSourceImpl(this.apiClient);

  @override
  Future<VendorProfileModel> getProfile() async {
    final response = await apiClient.get(ApiConstants.vendorProfile);
    return VendorProfileModel.fromJson(response);
  }

  @override
  Future<VendorProfileModel> updateProfile(
    VendorUpdateProfileRequestModel request,
  ) async {
    final response = await apiClient.put(
      ApiConstants.vendorProfile,
      data: request.toJson(),
    );
    return VendorProfileModel.fromJson(response);
  }

  @override
  Future<void> registerVendor(VendorRegisterRequestModel request) async {
    await apiClient.post(
      ApiConstants.vendorRegister,
      data: request.toJson(),
    );
  }

  @override
  Future<String> uploadLogo(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    });
    final response = await apiClient.post(
      ApiConstants.vendorProfileLogo,
      data: formData,
    );
    return _extractUrl(response);
  }

  @override
  Future<String> uploadCover(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    });
    final response = await apiClient.post(
      ApiConstants.vendorProfileCover,
      data: formData,
    );
    return _extractUrl(response);
  }

  /// الـ swagger بيرجع `data` كـ String (الرابط) مباشرة لـ endpoints الرفع.
  String _extractUrl(dynamic response) {
    if (response is Map<String, dynamic> && response['data'] is String) {
      return response['data'] as String;
    }
    if (response is String) return response;
    return '';
  }
}
