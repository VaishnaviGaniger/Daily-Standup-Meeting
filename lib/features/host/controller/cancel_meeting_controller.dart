import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/host/controller/meeting_update_host_controller.dart';

class CancelMeetingController extends GetxController {
  var isLoading = false.obs;

  Future<void> cancelMeeting(int id, Map<String, dynamic> input) async {
    try {
      isLoading.value = true;
      final apiresponse = await ApiServices.cancelMeeting(id, input);
      print("Meeting Response: $apiresponse");

      Get.snackbar(
        "✅ Success",
        "Meeting cancelled successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: EdgeInsets.all(12),
        borderRadius: 10,
        duration: Duration(seconds: 2),
      );

      final meetingController = Get.find<MeetingUpdateHostController>();
      meetingController.meetings.removeWhere((m) => m.id == id);

      print("Meeting cancel ");
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading.value = false;
    }
  }
}
