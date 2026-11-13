import 'package:flutter/foundation.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  bool _initialized = false;
  bool get isInitialized => _initialized;
  dynamic get client => null;

  Future<void> initialize() async {
    try {
      _initialized = true;
      debugPrint("SupabaseService initialized in auth backend integration mode.");
    } catch (e) {
      debugPrint("SupabaseService init info: $e");
    }
  }
}
