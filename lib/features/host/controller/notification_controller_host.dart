import 'package:get/get.dart';

class NotificationController extends GetxController {
  var unreadCount = 0.obs; // set 3 initially

  void setUnreadCount(int count) {
    unreadCount.value = count;
  }

  void increment() {
    unreadCount++;
  }

  void clearNotifications() {
    unreadCount.value = 0;
  }
}
