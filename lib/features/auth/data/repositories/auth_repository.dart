import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();
  final SecureStorageService _storageService = SecureStorageService();

  Future<UserModel> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {
        'username': email,
        'password': password,
      },
    );

    final user = UserModel.fromJson(response.data);
    if (user.token != null) {
      await _storageService.saveToken(user.token!);
    }
    return user;
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
  }
}
