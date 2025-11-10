import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/employees/model/emp_profile_model.dart';

class UpdateProfileController extends GetxController {
  var isLoading = false.obs;
  var profile = Rx<EmpProfileModel?>(null);

  Future<void> fetchprofile() async {
    isLoading.value = true;
    final data = await ApiServices.empprofile();
    profile.value = data;
    isLoading.value = false;
  }

  Future<void> updateprofile(Map<String, dynamic> input) async {
    if (profile.value == null) return;
    isLoading.value = true;

    final updatedData = await ApiServices.updateprofile(input);
    if (updatedData != null) {
      profile.value = updatedData; // update the model
      print("Update $updatedData");
      Get.snackbar(
        "✅ Success",
        "Profile updated successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: AppColors.white,
        margin: EdgeInsets.all(12),
        borderRadius: 10,
        duration: Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        "❌ Error",
        "Failed to update profile",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: AppColors.white,
        margin: EdgeInsets.all(12),
        borderRadius: 10,
        duration: Duration(seconds: 2),
      );
    }
    isLoading.value = false;
  }
}
