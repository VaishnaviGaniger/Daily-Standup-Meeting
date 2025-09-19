import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/employees/model/submit_daily_task.dart';

class SubmitDailyTaskController extends GetxController {
  var isLoading = false.obs;

  Future<void> dailyTask(List<SubmitDailyTaskModel> tasks) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> requestBody = {};
      for (int i = 0; i < tasks.length; i++) {
        requestBody.addAll(tasks[i].toJson(i + 1)); // index starts from 1
      }
      final apiresponse = await ApiServices.submitdailytask(requestBody);
      if (apiresponse != null) {
        Get.snackbar(
          'Tasks report submitted',
          apiresponse.detail,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Future.delayed(const Duration(seconds: 3), () {
          Get.back();
        });
      } else {
        Get.snackbar(
          'Error',
          'Task Submission fails',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("error");
      // Get.snackbar(
      //   'Error',
      //   'An error occurred: $e',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    } finally {
      isLoading.value = false;
    }
  }
}
