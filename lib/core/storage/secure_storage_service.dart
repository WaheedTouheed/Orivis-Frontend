import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _keyToken = 'auth_token';
  static const String _keyUserRole = 'user_role';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  Future<void> saveUserRole(String role) async {
    await _storage.write(key: _keyUserRole, value: role);
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: _keyUserRole);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyUserRole);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
