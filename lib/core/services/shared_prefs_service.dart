import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _tokenKey = 'auth_token';

  static SharedPreferences? prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Save token after login
  static Future<void> saveToken(String token) async {
    await prefs?.setString(_tokenKey, token);
    print("Token saved: $token");
  }

  // Get token for API calls
  static String? getToken() {
    final token = prefs?.getString(_tokenKey);
    print(' Get token: $token');
    return token;
  }

  // Remove token on logout
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs?.remove(_tokenKey);
    print('Token removed');
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  //storing profile
}
