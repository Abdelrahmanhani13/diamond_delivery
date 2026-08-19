import 'package:diamond_customer/core/api/api_error.dart';
import 'package:equatable/equatable.dart';


abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  List<ApiError>? get errors => null;

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  @override
  final List<ApiError>? errors;
  
  const ServerFailure({required super.message, super.statusCode, this.errors});
  
  @override
  List<Object?> get props => [message, statusCode, errors];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Session expired, please login again',
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Please check your internet connection',
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'An unexpected error occurred'});
}

class LocationFailure extends Failure {
  const LocationFailure({required super.message});
}
