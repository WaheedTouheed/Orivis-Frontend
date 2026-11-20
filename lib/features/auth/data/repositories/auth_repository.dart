import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();
  final SecureStorageService _storageService = SecureStorageService();

  Future<UserModel> login({
    required String email,
    required String password,
    String role = 'grower',
  }) async {
    final payload = {
      'email': email,
      'password': password,
    };

    final endpointsToTry = [
      ApiEndpoints.login,
      '/api/v1/auth/login',
    ];

    ApiException? lastError;

    for (var endpoint in endpointsToTry) {
      try {
        final response = await _apiClient.post(endpoint, data: payload);
        final data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          final user = UserModel.fromJson(data);
          final token = user.token ?? data['access_token'] ?? data['token'];
          if (token != null && token.toString().isNotEmpty) {
            await _storageService.saveToken(token.toString());
          }
          final userRole = user.role.isNotEmpty ? user.role : role;
          await _storageService.saveUserRole(userRole);
          return user;
        }
      } on ApiException catch (e) {
        lastError = e;
        if (e.statusCode != 404) {
          rethrow;
        }
      } catch (e) {
        lastError = ApiException(
          message:
              'Unable to connect to server. Please check your network and backend URL.',
        );
      }
    }

    throw lastError ??
        ApiException(
          message:
              'Invalid email or password. Please check your credentials and try again.',
        );
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? phone,
    String? businessName,
    String? location,
  }) async {
    final payload = {
      'email': email,
      'password': password,
      'confirm_password': password,
      'full_name': fullName,
      'role': role,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (phone != null && phone.isNotEmpty) 'phone_number': phone,
      if (businessName != null && businessName.isNotEmpty)
        'business_name': businessName,
      if (location != null && location.isNotEmpty) 'location': location,
      if (location != null && location.isNotEmpty)
        'business_location': location,
    };

    final endpointsToTry = [
      ApiEndpoints.signup,
      ApiEndpoints.register,
      '/api/v1/auth/signup',
      '/api/v1/auth/register',
    ];

    ApiException? lastError;

    for (var endpoint in endpointsToTry) {
      try {
        final response = await _apiClient.post(endpoint, data: payload);
        final data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          final user = UserModel.fromJson(data);
          final token = user.token ?? data['access_token'] ?? data['token'];
          if (token != null && token.toString().isNotEmpty) {
            await _storageService.saveToken(token.toString());
          }
          final userRole = user.role.isNotEmpty ? user.role : role;
          await _storageService.saveUserRole(userRole);
          return user;
        }
      } on ApiException catch (e) {
        lastError = e;
        if (e.statusCode != 404) {
          rethrow;
        }
      } catch (e) {
        lastError = ApiException(
          message:
              'Unable to connect to server. Please check your network and backend URL.',
        );
      }
    }

    throw lastError ??
        ApiException(
          message:
              'Signup failed. Please check your information and try again.',
        );
  }

  Future<bool> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final payload = {
      'email': email,
      'otp': otp,
      'token': otp,
    };

    final endpointsToTry = [
      ApiEndpoints.verifyOtp,
      '/api/v1/auth/verify-otp',
    ];

    ApiException? lastError;

    for (var endpoint in endpointsToTry) {
      try {
        final response = await _apiClient.post(endpoint, data: payload);
        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = response.data;
          if (data is Map<String, dynamic>) {
            final token = data['access_token'] ?? data['token'];
            if (token != null && token.toString().isNotEmpty) {
              await _storageService.saveToken(token.toString());
            }
            if (data['role'] != null) {
              await _storageService.saveUserRole(data['role'].toString());
            }
          }
          return true;
        }
      } on ApiException catch (e) {
        lastError = e;
        if (e.statusCode != 404) {
          rethrow;
        }
      } catch (e) {
        lastError = ApiException(
          message:
              'Unable to connect to server. Please check your network and backend URL.',
        );
      }
    }

    if (lastError != null) {
      throw lastError;
    }
    return false;
  }

  Future<void> resendOtp({required String email}) async {
    final payload = {'email': email};
    final endpointsToTry = [
      '/auth/resend-otp',
      '/api/v1/auth/resend-otp',
    ];

    ApiException? lastError;

    for (var endpoint in endpointsToTry) {
      try {
        await _apiClient.post(endpoint, data: payload);
        return;
      } on ApiException catch (e) {
        lastError = e;
        if (e.statusCode != 404) {
          rethrow;
        }
      } catch (_) {}
    }

    if (lastError != null) {
      throw lastError;
    }
  }

  Future<void> forgotPassword({required String email}) async {
    final payload = {'email': email};
    final endpointsToTry = [
      ApiEndpoints.forgotPassword,
      '/api/v1/auth/forgot-password',
    ];

    ApiException? lastError;

    for (var endpoint in endpointsToTry) {
      try {
        await _apiClient.post(endpoint, data: payload);
        return;
      } on ApiException catch (e) {
        lastError = e;
        if (e.statusCode != 404) {
          rethrow;
        }
      } catch (_) {}
    }

    if (lastError != null) {
      throw lastError;
    }
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
    String? token,
  }) async {
    final payload = {
      'email': email,
      'new_password': newPassword,
      'token': token,
    };

    final endpointsToTry = [
      ApiEndpoints.resetPassword,
      '/api/v1/auth/reset-password',
    ];

    ApiException? lastError;

    for (var endpoint in endpointsToTry) {
      try {
        await _apiClient.post(endpoint, data: payload);
        return;
      } on ApiException catch (e) {
        lastError = e;
        if (e.statusCode != 404) {
          rethrow;
        }
      } catch (_) {}
    }

    if (lastError != null) {
      throw lastError;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.profile);
      if (response.data != null && response.data is Map<String, dynamic>) {
        return UserModel.fromJson(response.data);
      }
    } catch (_) {}
    return null;
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (_) {}
    await _storageService.clearAll();
  }
}
