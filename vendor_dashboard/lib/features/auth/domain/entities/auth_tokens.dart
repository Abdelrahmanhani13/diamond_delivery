import 'package:equatable/equatable.dart';
import 'package:vendor_dashboard/features/auth/domain/entities/auth_tokens.dart';

class AuthTokens extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenExpiresAt;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresAt,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, accessTokenExpiresAt];
}
