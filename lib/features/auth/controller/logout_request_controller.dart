import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/core/services/shared_prefs_service.dart';
import 'package:message_notifier/features/auth/view/login_screen.dart';

class LogoutRequestController extends GetxController {
  var isLoading = false.obs;

  Future<void> logout() async {
    try {
      isLoading.value = true;
      final apiresponse = await ApiServices.logout();
      print("Logout apiresponse : $apiresponse");
      if (apiresponse!["message"] == "Logged out successfully") {
        await SharedPrefsService.prefs?.clear();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(
              "Logout Successfully",
              style: TextStyle(color: AppColors.white),
            ),
            backgroundColor: Color(0xFF2E8B7F),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            duration: Duration(seconds: 3),
          ),
        );

        Get.offAll(LoginScreen());
      } else {
        print("Error");
        //Get.snackbar("Logout Failed", apiresponse["error"] ?? "Unknown error");
      }
    } catch (e) {
      print("Error $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
