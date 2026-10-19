import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8000/api/v1';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/users/me';

  // Feature Endpoints
  static const String items = '/items';
}
