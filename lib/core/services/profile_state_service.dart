import 'dart:io';
import 'package:flutter/foundation.dart';

class ProfileStateService extends ChangeNotifier {
  static final ProfileStateService _instance = ProfileStateService._internal();
  factory ProfileStateService() => _instance;
  ProfileStateService._internal();

  File? _profileImageFile;
  String _userName = 'User';
  String _userEmail = 'user@example.com';
  String _userPhone = '';

  File? get profileImageFile => _profileImageFile;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;

  Future<void> loadProfile() async {}

  Future<void> setProfileImage(File file) async {
    _profileImageFile = file;
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    File? imageFile,
  }) async {
    if (name != null && name.isNotEmpty) _userName = name;
    if (email != null && email.isNotEmpty) _userEmail = email;
    if (phone != null) _userPhone = phone;
    if (imageFile != null) _profileImageFile = imageFile;
    notifyListeners();
  }

  Future<void> updateProfileImage(String path) async {
    _profileImageFile = File(path);
    notifyListeners();
  }

  Future<void> clearProfileImage() async {
    _profileImageFile = null;
    notifyListeners();
  }
}
