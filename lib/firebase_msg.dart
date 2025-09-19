import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMsg {
  final msgService = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    // Ask for notification permissions
    await msgService.requestPermission();

    // Get the FCM token properly
    String? token = await msgService.getToken();
    print("FCM Token : $token");

    // Background handler
    FirebaseMessaging.onBackgroundMessage(handleNotification);

    // Foreground handler
    FirebaseMessaging.onMessage.listen(handleNotification);
  }
}

Future<void> handleNotification(RemoteMessage msg) async {
  print("Notification Received: ${msg.notification?.title}");
}
