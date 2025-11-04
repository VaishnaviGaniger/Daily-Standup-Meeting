import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _tokenKey = 'auth_token';
  static const String _fcmTokenKey = 'fcm_token';
  static const String _role = 'role';

  static SharedPreferences? prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  //------------------- Auth Token ----------------------
  // Save token after login
  static Future<void> saveToken(String token) async {
    await prefs?.setString(_tokenKey, token);
    print("Token saved: $token");
  }

  // Get token for API calls
  static String? getToken() {
    final token = prefs?.getString(_tokenKey);
    print('Get token: $token');
    return token;
  }

  //-------------------- Role ------------------------------
  static Future<void> saveRole(String role) async {
    await prefs?.setString(_role, role);
    print("Role saved: $role");
  }

  static String? getRole() {
    final role = prefs?.getString(_role);
    print("Get Role: $role");
    return role;
  }

  // Remove token on logout
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    print('Token removed');
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = getToken();
    return token != null;
  }

  //storing profile

  // ---------------- FCM TOKEN ----------------

  static Future<void> saveFcmToken(String token) async {
    await prefs?.setString(_fcmTokenKey, token);
    print("FCM Token saved: $token");
  }

  static String? getFcmToken() {
    final token = prefs?.getString(_fcmTokenKey);
    print('Get FCM Token: $token');
    return token;
  }

  static Future<void> removeFcmToken() async {
    await prefs?.remove(_fcmTokenKey);
    print('FCM Token removed');
  }

  static Future<void> storeIp(String newIp) async {
    await prefs?.setString('stored_ip', newIp);
  }

  static String? getStoredIp() {
    return prefs?.getString('stored_ip');
  }
}
