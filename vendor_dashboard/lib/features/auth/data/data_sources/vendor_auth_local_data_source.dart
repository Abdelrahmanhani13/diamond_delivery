import 'dart:convert';

import '../../../../core/cache/secure_storage_service.dart';
import 'package:vendor_dashboard/core/cache/secure_storage_service.dart';
import 'package:vendor_dashboard/features/auth/data/datasources/vendor_auth_local_data_source.dart';

abstract class VendorAuthLocalDataSource {
  Future<void> saveTokens(
    String accessToken,
    String refreshToken,
    DateTime accessTokenExpiresAt,
  );
  Future<void> saveUserData(Map<String, dynamic> userData);
  Future<void> clearAll();
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<DateTime?> getAccessTokenExpiresAt();
  Future<Map<String, dynamic>?> getUserData();
  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements VendorAuthLocalDataSource {
  final SecureStorageService _storageService;

  AuthLocalDataSourceImpl(this._storageService);

  static const String keyUserData = 'User_Data';

  @override
  Future<void> saveTokens(
    String accessToken,
    String refreshToken,
    DateTime accessTokenExpiresAt,
  ) async {
    await _storageService.write(
      SecureStorageServiceImpl.keyAccessToken,
      accessToken,
    );
    await _storageService.write(
      SecureStorageServiceImpl.keyRefreshToken,
      refreshToken,
    );
    await _storageService.write(
      SecureStorageServiceImpl.keyAccessTokenExpiresAt,
      accessTokenExpiresAt.toIso8601String(),
    );
  }

  @override
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storageService.write(keyUserData, json.encode(userData));
  }

  @override
  Future<void> clearAll() async {
    await _storageService.delete(SecureStorageServiceImpl.keyAccessToken);
    await _storageService.delete(SecureStorageServiceImpl.keyRefreshToken);
    await _storageService.delete(
      SecureStorageServiceImpl.keyAccessTokenExpiresAt,
    );
    await _storageService.delete(keyUserData);
  }

  @override
  Future<String?> getAccessToken() async {
    return await _storageService.read(SecureStorageServiceImpl.keyAccessToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _storageService.read(SecureStorageServiceImpl.keyRefreshToken);
  }

  @override
  Future<DateTime?> getAccessTokenExpiresAt() async {
    final dateStr = await _storageService.read(
      SecureStorageServiceImpl.keyAccessTokenExpiresAt,
    );
    if (dateStr != null && dateStr.isNotEmpty) {
      return DateTime.tryParse(dateStr);
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>?> getUserData() async {
    final raw = await _storageService.read(keyUserData);
    if (raw != null && raw.isNotEmpty) {
      return json.decode(raw) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
