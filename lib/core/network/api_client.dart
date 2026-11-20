import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import 'api_exceptions.dart';
import 'api_interceptors.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _dio.interceptors.add(ApiInterceptors());
  }

  List<String> get _candidateUrls => [
        ApiEndpoints.baseUrl,
        'http://127.0.0.1:8000',
        'http://localhost:8000',
        'http://192.168.137.23:8000',
        'http://192.168.137.1:8000',
        'http://10.0.2.2:8000',
      ];

  Future<Response> _executeWithFallback(
    Future<Response> Function(String base) requestFn,
  ) async {
    DioException? lastDioError;
    final tried = <String>{};

    for (final base in _candidateUrls) {
      if (tried.contains(base)) continue;
      tried.add(base);

      try {
        _dio.options.baseUrl = base;
        final response = await requestFn(base);
        return response;
      } on DioException catch (e) {
        lastDioError = e;
        // If the server answered with an HTTP error response (e.g. 400, 401, 404, 422),
        // the server was reached successfully! Do not retry alternative base URLs.
        if (e.response != null) {
          throw ApiException.fromDioException(e);
        }
        // Socket/network connect error or timeout: try next candidate URL
        continue;
      }
    }

    if (lastDioError != null) {
      throw ApiException.fromDioException(lastDioError);
    }
    throw ApiException(
      message: 'Unable to connect to server. Please verify backend server IP and Wi-Fi connection.',
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _executeWithFallback(
      (_) => _dio.get(path, queryParameters: queryParameters),
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _executeWithFallback(
      (_) => _dio.post(path, data: data, queryParameters: queryParameters),
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
  }) async {
    return await _executeWithFallback(
      (_) => _dio.put(path, data: data),
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
  }) async {
    return await _executeWithFallback(
      (_) => _dio.delete(path, data: data),
    );
  }
}
