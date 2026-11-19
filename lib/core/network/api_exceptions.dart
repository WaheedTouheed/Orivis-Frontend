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
              'Unable to connect to the server. Please check your internet connection and try again.',
        );

      case DioExceptionType.badResponse:
        final response = dioException.response;
        final statusCode = response?.statusCode;
        final data = response?.data;

        if (statusCode == 401) {
          return ApiException(
            message:
                'Invalid email or password. Please check your credentials and try again.',
            statusCode: 401,
          );
        }

        if (response != null && data is Map<String, dynamic>) {
          final detail = data['detail'] ?? data['message'] ?? data['error'];
          if (detail != null) {
            final detailStr = detail.toString();
            if (detailStr.toLowerCase().contains('expire')) {
              return ApiException(
                message:
                    'Your verification code has expired. Please request a new code.',
                statusCode: statusCode,
              );
            }
            if (detailStr.toLowerCase().contains('otp') ||
                detailStr.toLowerCase().contains('code')) {
              return ApiException(
                message: 'Invalid verification code. Please enter the correct OTP.',
                statusCode: statusCode,
              );
            }
            return ApiException(
              message: detailStr,
              statusCode: statusCode,
            );
          }
        }

        if (statusCode != null && statusCode >= 500) {
          return ApiException(
            message: 'Something went wrong. Please try again later.',
            statusCode: statusCode,
          );
        }

        return ApiException(
          message: 'Authentication failed. Please check your details and try again.',
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return ApiException(message: 'Request to server was cancelled.');

      default:
        return ApiException(
          message: 'Something went wrong. Please try again later.',
        );
    }
  }

  @override
  String toString() => message;
}
