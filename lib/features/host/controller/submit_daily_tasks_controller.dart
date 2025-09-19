import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/employees/model/submit_daily_task.dart';

class SubmitDailyTasksController extends GetxController {
  var isLoading = false.obs;

  Future<void> dailyTask(List<SubmitDailyTaskModel> tasks) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> requestBody = {};
      for (int i = 0; i < tasks.length; i++) {
        requestBody.addAll(tasks[i].toJson(i + 1));
      }

      final apiresponse = await ApiServices.submitdailytasks(requestBody);

      if (apiresponse != null && apiresponse["detail"] != null) {
        Get.snackbar(
          'Success',
          apiresponse["detail"],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        print("Error");
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
