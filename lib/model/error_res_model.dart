class ErrorResponseModel {
  bool success;
  ErrorResponse error;

  ErrorResponseModel({
    required this.success,
    required this.error,
  });

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) {
    return ErrorResponseModel(
      success: json['success'] ?? false,
      error: json['error'] != null ? ErrorResponse.fromJson(json['error']) : ErrorResponse(),
    );
  }
}

class ErrorResponse {
  String message;
  String type;
  int code;

  ErrorResponse({
    this.message = '',
    this.type = '',
    this.code = 0,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      code: json['code'] ?? 0,
    );
  }
}
