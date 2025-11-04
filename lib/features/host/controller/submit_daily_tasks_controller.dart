import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/host/model/submit_daily_tasks_model.dart';

class SubmitDailyTasksController extends GetxController {
  var isLoading = false.obs;

  /// Method to submit the daily updates
  Future<void> submitDailyUpdates(SubmitDailyUpdatesModel model) async {
    try {
      isLoading.value = true;

      // Convert the model to JSON for API request
      final requestBody = model.toJson();
      debugPrint("Request Body: $requestBody");

      // Call your API service
      final response = await ApiServices.submitdailytasks(requestBody);
      debugPrint("Response: ${response.message}");

      // Check and show snackbar based on response
      if (response.message.contains("✅")) {
        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: AppColors.white,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to submit daily updates',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: AppColors.white,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        );
        print("one");
      }
    } catch (e) {
      debugPrint("Error submitting daily updates: $e");
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: AppColors.white,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:message_notifier/config/app_colors.dart';
// import 'package:message_notifier/core/services/api_services.dart';
// import 'package:message_notifier/features/host/model/submit_daily_tasks_model.dart';

// class SubmitDailyTasksController extends GetxController {
//   var isLoading = false.obs;

//   Future<void> submitDailyUpdates(SubmitDailyUpdatesModel model) async {
//     try {
//       isLoading.value = true;

//       final requestBody = model.toJson();
//       print("Request Body: $requestBody");

//       final response = await ApiServices.submitdailytasks(requestBody);

//       if (response.detail.isNotEmpty) {
//         Get.snackbar(
//           '✅ Success',
//           response.detail,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: AppColors.white,
//         );
//       } else {
//         Get.snackbar(
//           '⚠️ Error',
//           'Failed to submit daily updates',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: AppColors.white,
//         );
//       }
//     } catch (e) {
//       print("❌ Error submitting daily updates: $e");
//       Get.snackbar(
//         'Error',
//         'Something went wrong. Please try again.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: AppColors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }


