import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';

class ApiInterceptors extends Interceptor {
  final SecureStorageService _storage = SecureStorageService();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Clear token on 401 Unauthorized
      _storage.deleteToken();
    }
    super.onError(err, handler);
  }
}
