import 'package:diamond_customer/core/api/api_error.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/register_response.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final RegisterResponse response;
  const RegisterSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class RegisterError extends RegisterState {
  final String message;
  final List<ApiError>? errors;
  const RegisterError(this.message, {this.errors});

  @override
  List<Object?> get props => [message, errors];
}
