import '../../../../core/services/supabase_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final SecureStorageService _storageService = SecureStorageService();

  Future<UserModel> login({
    required String email,
    required String password,
    String role = 'grower',
  }) async {
    final supabase = SupabaseService();

    if (supabase.isInitialized && supabase.client != null) {
      try {
        final response = await supabase.client!.auth.signInWithPassword(
          email: email,
          password: password,
        );

        final user = response.user;
        if (user == null) {
          throw Exception('Login failed: User record not found.');
        }

        // Save token to secure storage
        if (response.session?.accessToken != null) {
          await _storageService.saveToken(response.session!.accessToken);
        }

        // Fetch profile
        final profileResponse = await supabase.client!
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (profileResponse != null) {
          return UserModel.fromJson(profileResponse);
        }

        return UserModel(
          id: user.id,
          email: user.email ?? email,
          name: user.userMetadata?['full_name'] ?? email.split('@').first,
          role: role,
        );
      } catch (e) {
        rethrow;
      }
    }

    // Fallback Mode (Demo / Offline)
    final mockUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: email.split('@').first,
      role: role,
      token: 'demo_access_token_${DateTime.now().millisecondsSinceEpoch}',
    );
    await _storageService.saveToken(mockUser.token!);
    return mockUser;
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
    final supabase = SupabaseService();

    if (supabase.isInitialized && supabase.client != null) {
      final response = await supabase.client!.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': role,
        },
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Registration failed.');
      }

      final profileData = {
        'id': user.id,
        'email': email,
        'full_name': fullName,
        'role': role,
        'phone': phone,
        'business_name': businessName,
        'location': location,
        'created_at': DateTime.now().toIso8601String(),
      };

      try {
        await supabase.client!.from('profiles').upsert(profileData);
      } catch (_) {}

      if (response.session?.accessToken != null) {
        await _storageService.saveToken(response.session!.accessToken);
      }

      return UserModel.fromJson(profileData);
    }

    // Fallback Mode
    final mockUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: fullName,
      role: role,
      phone: phone,
      location: location,
      businessName: businessName,
      token: 'demo_access_token_${DateTime.now().millisecondsSinceEpoch}',
    );
    await _storageService.saveToken(mockUser.token!);
    return mockUser;
  }

  Future<void> resetPassword({required String email}) async {
    final supabase = SupabaseService();
    if (supabase.isInitialized && supabase.client != null) {
      await supabase.client!.auth.resetPasswordForEmail(email);
    }
  }

  Future<void> logout() async {
    final supabase = SupabaseService();
    if (supabase.isInitialized && supabase.client != null) {
      try {
        await supabase.client!.auth.signOut();
      } catch (_) {}
    }
    await _storageService.deleteToken();
  }
}
