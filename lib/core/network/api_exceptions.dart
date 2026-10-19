import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  factory ApiException.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(message: 'Connection timeout with server.');
      case DioExceptionType.sendTimeout:
        return ApiException(message: 'Send timeout in connection with server.');
      case DioExceptionType.receiveTimeout:
        return ApiException(message: 'Receive timeout in connection with server.');
      case DioExceptionType.badResponse:
        final response = dioException.response;
        if (response != null && response.data != null) {
          final detail = response.data['detail'];
          if (detail != null) {
            return ApiException(
              message: detail.toString(),
              statusCode: response.statusCode,
            );
          }
        }
        return ApiException(
          message: 'Received invalid status code: ${response?.statusCode}',
          statusCode: response?.statusCode,
        );
      case DioExceptionType.cancel:
        return ApiException(message: 'Request to server was cancelled.');
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No Internet connection or server is unreachable.',
        );
      default:
        return ApiException(message: 'Something went wrong. Please try again.');
    }
  }

  @override
  String toString() => message;
}
