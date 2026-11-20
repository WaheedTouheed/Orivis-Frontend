import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get baseUrl {
    final envUrl = dotenv.env['BASE_URL'];
    if (envUrl != null && envUrl.isNotEmpty) {
      return envUrl;
    }
    // Preferred mobile URL (Supports USB adb reverse & Wi-Fi)
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://127.0.0.1:8000';
    }
    return 'http://192.168.137.23:8000';
  }

  static List<String> get candidateBaseUrls => [
        if (dotenv.env['BASE_URL'] != null && dotenv.env['BASE_URL']!.isNotEmpty)
          dotenv.env['BASE_URL']!,
        'http://192.168.137.23:8000/api/v1',
        'http://192.168.137.23:8000',
        'http://192.168.137.1:8000',
        'http://10.0.2.2:8000',
        'http://127.0.0.1:8000',
        'http://localhost:8000',
      ];

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String loginToken = '/auth/token';
  static const String register = '/auth/register';
  static const String signup = '/auth/signup';
  static const String verifyOtp = '/auth/verify-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String profile = '/users/me';
  static const String logout = '/auth/logout';
}
