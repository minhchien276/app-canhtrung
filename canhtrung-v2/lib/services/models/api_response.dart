// ignore_for_file: public_member_api_docs, sort_constructors_first
class ApiResponseStatus {
  final bool status;
  final String message;
  final int? statusCode;
  ApiResponseStatus({
    required this.status,
    required this.message,
    required this.statusCode,
  });

  factory ApiResponseStatus.fromMap(Map<String, dynamic> map) {
    return ApiResponseStatus(
      status: map['status'] ?? false,
      message: map['message'] ?? '',
      statusCode: null,
    );
  }

  String get responseMessage => message;
}

class ApiResponse<T> {
  final ApiResponseStatus status;
  final T data;
  ApiResponse({
    required this.status,
    required this.data,
  });

  bool get isOk => status.status;
}
