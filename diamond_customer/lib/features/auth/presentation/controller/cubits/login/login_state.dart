import 'package:diamond_customer/core/api/api_error.dart';
import 'package:equatable/equatable.dart';
import 'package:diamond_customer/features/auth/domain/entities/auth_tokens.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final AuthTokens tokens;
  const LoginSuccess(this.tokens);

  @override
  List<Object?> get props => [tokens];
}

class LoginError extends LoginState {
  final String message;
  final List<ApiError>? errors;

  const LoginError(this.message, {this.errors});

  @override
  List<Object?> get props => [message, errors];
}
