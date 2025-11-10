import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/core/services/shared_prefs_service.dart';
import 'package:message_notifier/features/auth/model/login_request_model.dart';
import 'package:message_notifier/features/employees/view/emp_dashboard_screen.dart';
import 'package:message_notifier/features/host/view/host_dashboard_screen.dart';
import 'package:message_notifier/firebase_msg.dart';

class LoginScreenController extends GetxController {
  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      final input = LoginRequestModel(email: email, password: password);
      final response = await ApiServices().login(input);
      print("Login Data: $response");

      // --- FCM token  ---
      final String? fcmToken = await FirebaseMsg().msgService.getToken();
      if (fcmToken != null) {
        await SharedPrefsService.saveFcmToken(fcmToken);
        await FirebaseMsg().sendTokenToServer(fcmToken);
      }

      if (response['message'] == "Login successful.") {
        final String? rawRole = response['role'];
        final String role = (rawRole ?? '')
            .toLowerCase()
            .trim(); // "lead" | "employee" |

        // ----- Save token -----
        final String? token = response['token'];
        if (token != null && token.isNotEmpty) {
          await SharedPrefsService.saveToken(token);
          print("Token Data : $token");
        } else {
          Get.snackbar("Login Failed", "Token missing in response");
          return;
        }

        final bool isApproved = (response['is_approved'] == true);
        final bool isPending = (response['is_pending'] == true);

        await SharedPrefsService.saveRole(role);
        print("Saved role: $role");
        print("Read-back role: ${SharedPrefsService.getRole()}");

        if (!isApproved || isPending) {
          Get.snackbar(
            "Request Pending",
            "Your account is not yet approved. Please try again later.",
          );
          return;
        }

        // Navigate AFTER saves complete
        if (role == "employee") {
          Get.offAll(() => const EmpDashboardScreen());
        } else if (role == "lead") {
          Get.offAll(() => const HostDashboardScreen());
        } else {
          Get.snackbar("Login Failed", "Unknown role: ${rawRole ?? 'null'}");
        }
      } else {
        Get.snackbar("Login Failed", response['message'] ?? " ");
      }
    } catch (e) {
      print("error occurred $e");
      Get.snackbar(
        'Login Failed',
        'You need to register first and your account need to approve.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        dismissDirection: DismissDirection.horizontal,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
