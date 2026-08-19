import 'api_error.dart';

class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final List<ApiError>? errors;
  final DateTime timestamp;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
    required this.timestamp,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] == null || fromJsonT == null
          ? null
          : fromJsonT(json['data']),
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => ApiError.fromJson(e as Map<String, dynamic>))
          .toList(),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }
}


