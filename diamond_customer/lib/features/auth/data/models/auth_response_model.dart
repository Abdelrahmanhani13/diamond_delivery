import '../../domain/entities/auth_tokens.dart';
import 'user_model.dart';

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
    Map<String, dynamic>? userJson;
    if (json['user'] is Map<String, dynamic>) {
      userJson = json['user'] as Map<String, dynamic>;
    } else if (json['userId'] != null ||
        json['id'] != null ||
        json['fullName'] != null ||
        json['name'] != null ||
        json['firstName'] != null) {
      userJson = json;
    }

    return AuthResponseModel(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      accessTokenExpiresAt: json['accessTokenExpiresAt'] != null
          ? DateTime.parse(json['accessTokenExpiresAt'])
          : DateTime.now().add(const Duration(minutes: 15)),
      user: userJson != null ? UserModel.fromJson(userJson) : null,
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
