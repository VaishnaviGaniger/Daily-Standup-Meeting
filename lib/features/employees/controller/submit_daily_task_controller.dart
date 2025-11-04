import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/host/model/submit_daily_tasks_model.dart';

class SubmitDailyTaskEmpController extends GetxController {
  var isLoading = false.obs;

  Future<void> submitDailyUpdates(SubmitDailyUpdatesModel model) async {
    try {
      isLoading.value = true;

      final requestBody = model.toJson();
      print("Request Body: $requestBody");

      final response = await ApiServices.submitdailytasks(requestBody);

      if (response.message.isNotEmpty) {
        Get.snackbar(
          '✅ Success',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: AppColors.white,
        );
      } else {
        Get.snackbar(
          '⚠️ Error',
          'Failed to submit daily updates',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: AppColors.white,
        );
      }
    } catch (e) {
      print("❌ Error submitting daily updates: $e");
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: AppColors.white,
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
// import 'package:message_notifier/features/employees/model/submit_daily_task.dart';

// class SubmitDailyTasksController extends GetxController {
//   var isLoading = false.obs;

//   Future<void> dailyTask(List<SubmitDailyTaskModel> tasks) async {
//     try {
//       isLoading.value = true;
//       final Map<String, dynamic> requestBody = {};
//       for (int i = 0; i < tasks.length; i++) {
//         requestBody.addAll(tasks[i].toJson(i + 1));
//       }
//       print("Request Body: $requestBody");

//       final apiresponse = await ApiServices.submitdailytasks(requestBody);

//       if (apiresponse.detail.isNotEmpty) {
//         Get.snackbar(
//           'Success',
//           apiresponse.detail,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: AppColors.white,
//         );
//         //Get.back();
//       } else {
//         Get.snackbar(
//           'Error',
//           'Failed to submit daily tasks',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: AppColors.white,
//         );
//       }
//     } catch (e) {
//       // Get.snackbar(
//       //   'Success',
//       //    '',
//       //     snackPosition: SnackPosition.BOTTOM,
//       //     backgroundColor: Colors.green,
//       //     colorText: AppColors.white,
//       // );
//       print("Error in submit daily task: $e");
//       // rethrow;
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:message_notifier/config/app_colors.dart';
// import 'package:message_notifier/core/services/api_services.dart';
// import 'package:message_notifier/features/employees/model/submit_daily_task.dart';

// class SubmitDailyTaskController extends GetxController {
//   var isLoading = false.obs;

//   Future<void> dailyTask(List<SubmitDailyTaskModel> tasks) async {
//     try {
//       isLoading.value = true;
//       final Map<String, dynamic> requestBody = {};
//       for (int i = 0; i < tasks.length; i++) {
//         requestBody.addAll(tasks[i].toJson(i + 1)); // index starts from 1
//       }
//       final apiresponse = await ApiServices.submitdailytask(requestBody);
//       if (apiresponse != null) {
//         Get.snackbar(
//           'Tasks report submitted',
//           apiresponse.detail,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: AppColors.white,
//         );
//         Future.delayed(const Duration(seconds: 3), () {
//           Get.back();
//         });
//       } else {
//         Get.snackbar(
//           'Error',
//           'Task Submission fails',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: AppColors.white,
//         );
//       }
//     } catch (e) {
//       print("error");
//       // Get.snackbar(
//       //   'Error',
//       //   'An error occurred: $e',
//       //   snackPosition: SnackPosition.BOTTOM,
//       //   backgroundColor: Colors.red,
//       //   colorText: AppColors.white,
//       // );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
