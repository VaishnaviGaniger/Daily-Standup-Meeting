import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/core/services/shared_prefs_service.dart';
import 'package:message_notifier/features/auth/model/login_request_model.dart';
import 'package:message_notifier/features/employees/view/emp_dashboard_items_screen.dart';
import 'package:message_notifier/features/employees/view/emp_dashboard_screen.dart';
import 'package:message_notifier/features/host/view/host_dashboard_items_Screen.dart';
import 'package:message_notifier/features/host/view/host_dashboard_screen.dart';
import 'package:message_notifier/firebase_msg.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final input = LoginRequestModel(email: email, password: password);
      final response = await ApiServices().login(input);
      final String token = response['token'];

      await SharedPrefsService.saveToken(token);
      // ------------------ Add FCM token integration ------------------
      String? fcmToken = await FirebaseMsg().msgService.getToken();
      if (fcmToken != null) {
        await SharedPrefsService.saveFcmToken(fcmToken);
        await FirebaseMsg().sendTokenToServer(fcmToken);
      }

      if (response['message'] == "Login successful.") {
        String role = response['role'];
        bool isApproved = response['is_approved'];

        await SharedPrefsService.saveRole(role);

        if (isApproved == true && role == "employee") {
          Get.offAll(() => const EmpDashboardScreen());
        } else if (isApproved == true && role == "lead") {
          //await FirebaseMessaging.instance.subscribeToTopic("techlead");
          Get.offAll(() => const HostDashboardScreen());
        } else {
          Get.snackbar(
            "Request Pending",
            "Your account is not yet approved. Please try again later.",
          );
        }
      } else {
        Get.snackbar(
          "Login Failed",
          response['message'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Login failed. Please try again. $e',
        backgroundColor: Colors.red,
        colorText: AppColors.white,
        dismissDirection: DismissDirection.horizontal,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
