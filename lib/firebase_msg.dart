import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:message_notifier/core/services/shared_prefs_service.dart';

class FirebaseMsg {
  final msgService = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    // Ask for notification permissions
    await msgService.requestPermission();
    
    // Get the FCM token properly
    String? token = await msgService.getToken();
    print("FCM Token : $token");

    if (token != null) {
      // Save locally
      await SharedPrefsService.saveFcmToken(token);

      // Send to backend
      await sendTokenToServer(token);
    }

    // Background handler
    FirebaseMessaging.onBackgroundMessage(handleNotification);

    // Foreground handler
    FirebaseMessaging.onMessage.listen(handleNotification);
  }

  /// Send FCM token to backend
  Future<void> sendTokenToServer(String token) async {
    try {
      final authToken = SharedPrefsService.getToken();
      if (authToken == null) {
        print("Auth token not found, cannot send FCM token.");
        return;
      }

      // Example API call (adjust endpoint as per backend)
      //   await ApiServices().sendFcmToken(token, authToken);
      //   print("FCM token sent to server successfully.");
    } catch (e) {
      print("Error sending FCM token to server: $e");
    }
  }
}

Future<void> handleNotification(RemoteMessage msg) async {
  print("Notification Received: ${msg.notification?.title}");
}
