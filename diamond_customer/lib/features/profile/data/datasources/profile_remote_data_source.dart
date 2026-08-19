import '../models/profile_model.dart';
import '../models/update_profile_request_model.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:diamond_customer/features/auth/data/data_sources/auth_local_data_source.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(UpdateProfileRequestModel request);
  Future<void> deleteProfile();
  Future<void> uploadProfileImage(String imagePath);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final AuthLocalDataSource _authLocalDataSource;

  ProfileRemoteDataSourceImpl(this._authLocalDataSource);

  @override
  Future<ProfileModel> getProfile() async {
    Map<String, dynamic> current =
        await _authLocalDataSource.getUserData() ?? {};

    debugPrint('🔍 [Profile] getUserData returned: $current');

    // Fallback: Recover user data from the JWT access token if
    // User_Data cache is missing or doesn't contain a name.
    if (current.isEmpty || (current['fullName'] ?? '').toString().isEmpty) {
      final token = await _authLocalDataSource.getAccessToken();
      debugPrint('🔍 [Profile] Token exists: ${token != null && token.isNotEmpty}');
      if (token != null && token.isNotEmpty) {
        // Print first 20 chars of token for identification
        debugPrint('🔍 [Profile] Token prefix: ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
        try {
          final parts = token.split('.');
          if (parts.length == 3) {
            String payload = parts[1];
            // Pad base64 to make it valid
            switch (payload.length % 4) {
              case 2:
                payload += '==';
                break;
              case 3:
                payload += '=';
                break;
            }
            final String decoded =
                utf8.decode(base64Url.decode(payload));
            final Map<String, dynamic> c = json.decode(decoded);

            debugPrint('🔍 [Profile] JWT claims keys: ${c.keys.toList()}');
            debugPrint('🔍 [Profile] JWT claims values: $c');

            // ASP.NET Core Identity claim keys
            const ns =
                'http://schemas.xmlsoap.org/ws/2005/05/identity/claims';

            final userId = c['$ns/nameidentifier'] ??
                c['nameid'] ??
                c['uid'] ??
                c['sub'] ??
                c['userId'] ??
                c['id'] ??
                '';
            final name = c['$ns/name'] ??
                c['$ns/givenname'] ??
                c['full_name'] ??
                c['fullName'] ??
                c['FullName'] ??
                c['name'] ??
                c['unique_name'] ??
                '';
            final email = c['$ns/emailaddress'] ??
                c['email'] ??
                c['emailAddress'] ??
                '';
            final phone = c['$ns/mobilephone'] ??
                c['phone_number'] ??
                c['phoneNumber'] ??
                '';

            debugPrint('🔍 [Profile] Extracted: userId=$userId, name=$name, email=$email, phone=$phone');

            // Merge JWT data into current (don't overwrite existing
            // non-empty values)
            current = {
              'userId': _firstNonEmpty(
                  userId.toString(), current['userId']?.toString()),
              'fullName': _firstNonEmpty(
                  name.toString(), current['fullName']?.toString()),
              'email': _firstNonEmpty(
                  email.toString(), current['email']?.toString()),
              'phoneNumber': _firstNonEmpty(
                  phone.toString(), current['phoneNumber']?.toString()),
            };

            // Persist so next read doesn't need to decode JWT again
            await _authLocalDataSource.saveUserData(current);
            debugPrint('🔍 [Profile] Saved recovered data: $current');
          }
        } catch (e) {
          debugPrint('🔍 [Profile] JWT decode error: $e');
        }
      }
    }

    // Extract name fields cleanly
    String firstName = (current['firstName'] ?? '').toString().trim();
    String lastName = (current['lastName'] ?? '').toString().trim();
    final fullName = (current['fullName'] ?? current['name'] ?? '').toString().trim();

    if (firstName.isEmpty && fullName.isNotEmpty) {
      final parts = fullName.split(' ');
      firstName = parts.first;
      if (parts.length > 1) {
        lastName = parts.skip(1).join(' ');
      }
    }

    final model = ProfileModel(
      id: current['userId']?.toString() ?? '',
      firstName: firstName,
      lastName: lastName,
      email: current['email']?.toString() ?? '',
      phoneNumber: current['phoneNumber']?.toString() ?? '',
      genderId: current['genderId'],
      dateOfBirth: current['dateOfBirth'],
    );

    debugPrint('🔍 [Profile] Final: firstName="${model.firstName}", lastName="${model.lastName}", email="${model.email}", phone="${model.phoneNumber}"');

    return model;
  }


  /// Returns the first non-null, non-empty string from the arguments.
  String _firstNonEmpty(String? a, String? b) {
    if (a != null && a.isNotEmpty) return a;
    if (b != null && b.isNotEmpty) return b;
    return '';
  }


  @override
  Future<ProfileModel> updateProfile(UpdateProfileRequestModel request) async {
    final current = await _authLocalDataSource.getUserData() ?? {};

    final updated = {
      ...current,
      'firstName': request.firstName,
      'lastName': request.lastName,
      'fullName': '${request.firstName} ${request.lastName}'.trim(),
      'email': request.email,
      'genderId': request.genderId,
      'dateOfBirth': request.dateOfBirth,
    };
    await _authLocalDataSource.saveUserData(updated);

    return ProfileModel(
      id: current['userId'] ?? '',
      firstName: request.firstName,
      lastName: request.lastName,
      email: request.email,
      phoneNumber: current['phoneNumber'] ?? '',
      genderId: request.genderId,
      dateOfBirth: request.dateOfBirth,
    );
  }

  @override
  Future<void> deleteProfile() async {
    await _authLocalDataSource.clearAll();
  }

  @override
  Future<void> uploadProfileImage(String imagePath) async {
    throw UnimplementedError(
      'Upload Profile Image is not available in the current API version',
    );
  }
}
