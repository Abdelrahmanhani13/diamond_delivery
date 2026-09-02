class ApiError {
  final String? code;
  final String? message;
  final String? field;

  const ApiError({this.code, this.message, this.field});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] as String?,
      message: json['message'] as String?,
      field: json['field'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (code != null) 'code': code,
      if (message != null) 'message': message,
      if (field != null) 'field': field,
    };
  }
}
