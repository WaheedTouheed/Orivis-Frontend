import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  factory ApiException.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return ApiException(
          message:
              'Unable to connect to server. Please verify backend server IP and Wi-Fi connection.',
        );

      case DioExceptionType.badResponse:
        final response = dioException.response;
        final statusCode = response?.statusCode;
        final data = response?.data;

        if (response != null && data != null) {
          if (data is Map<String, dynamic>) {
            final detail = data['detail'] ?? data['message'] ?? data['error'];
            if (detail != null) {
              if (detail is List && detail.isNotEmpty) {
                final firstErr = detail.first;
                if (firstErr is Map && firstErr['msg'] != null) {
                  return ApiException(
                    message: firstErr['msg'].toString(),
                    statusCode: statusCode,
                  );
                }
              }
              return ApiException(
                message: detail.toString(),
                statusCode: statusCode,
              );
            }
          } else if (data is String && data.isNotEmpty) {
            return ApiException(
              message: data,
              statusCode: statusCode,
            );
          }
        }

        if (statusCode == 401) {
          return ApiException(
            message:
                'Invalid email or password. Please check your credentials and try again.',
            statusCode: 401,
          );
        }

        return ApiException(
          message:
              'Server returned error (${statusCode ?? "Unknown"}). Please check submitted data.',
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return ApiException(message: 'Request to server was cancelled.');

      default:
        return ApiException(
          message: 'Something went wrong. Please check your server connection.',
        );
    }
  }

  @override
  String toString() => message;
}
