import 'package:message_notifier/core/services/shared_prefs_service.dart';


class AuthHelper {
  static bool isUserLogged() {
    final token = SharedPrefsService.getToken();
    return token != null && token.isNotEmpty;

  }
}