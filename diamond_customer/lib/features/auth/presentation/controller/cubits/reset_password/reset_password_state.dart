import 'package:diamond_customer/core/api/api_error.dart';
import 'package:equatable/equatable.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordError extends ResetPasswordState {
  final String message;
  final List<ApiError>? errors;
  const ResetPasswordError(this.message, {this.errors});

  @override
  List<Object?> get props => [message, errors];
}
