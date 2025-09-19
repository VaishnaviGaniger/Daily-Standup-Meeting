import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/core/services/shared_prefs_service.dart';
import 'package:message_notifier/features/auth/model/login_request_model.dart';
import 'package:message_notifier/features/employees/view/emp_dashboard_screen.dart';
import 'package:message_notifier/features/host/view/host_dashboard_screen.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final input = LoginRequestModel(email: email, password: password);
      final response = await ApiServices().login(input);
      final String token = response['token'];

      await SharedPrefsService.saveToken(token);

      if (response['message'] == "Login successful.") {
        String role = response['role'];
        bool isApproved = response['is_approved'];

        if (isApproved == true && role == "employee") {
          Get.offAll(() => const EmpDashboardScreen());
        } else if (isApproved == true && role == "lead") {
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
      // Get.snackbar(
      //   'Error',
      //   'Login failed. Please try again. $e',
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   dismissDirection: DismissDirection.horizontal,
      // );
    } finally {
      isLoading.value = false;
    }
  }
}
