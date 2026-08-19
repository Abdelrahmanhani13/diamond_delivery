class ApiError {
  final String? code;
  final String? message;
  final String? field;

  ApiError({this.code, this.message, this.field});

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
    code: json['code'] as String?,
    message: json['message'] as String?,
    field: json['field'] as String?,
  );
}
