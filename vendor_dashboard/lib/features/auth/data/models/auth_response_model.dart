import '../../domain/entities/auth_tokens.dart';
import 'user_model.dart';
import 'package:vendor_dashboard/features/auth/domain/entities/auth_tokens.dart';
import 'package:vendor_dashboard/features/auth/data/models/auth_response_model.dart';

class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenExpiresAt;
  final UserModel? user;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresAt,
    this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      accessTokenExpiresAt: json['accessTokenExpiresAt'] != null
          ? DateTime.parse(json['accessTokenExpiresAt'])
          : DateTime.now().add(const Duration(minutes: 15)),
      // In the new API docs, user fields are directly on the data object, not nested in a 'user' object.
      // So we parse the UserModel from the same json.
      user: json['userId'] != null ? UserModel.fromJson(json) : null,
    );
  }

  AuthTokens toTokensEntity() {
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessTokenExpiresAt: accessTokenExpiresAt,
    );
  }
}
