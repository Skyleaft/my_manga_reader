import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static const String _defaultBaseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:5126',
  );

  static String baseUrl = _defaultBaseUrl;

  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      baseUrl = prefs.getString('api_base_url') ?? _defaultBaseUrl;
    } catch (e) {
      // Fallback
    }
  }

  static Future<void> updateBaseUrl(String newUrl) async {
    baseUrl = newUrl;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('api_base_url', newUrl);
    } catch (e) {
      // Ignored
    }
  }
}
