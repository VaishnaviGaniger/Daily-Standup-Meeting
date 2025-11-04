import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/host/model/schedule_meeting_model.dart';

class ScheduleMeetingController extends GetxController {
  var isLoading = false.obs;
  var meeting = <ScheduleMeetingModel>[].obs;

  Future<void> schedulemeeting(
    List<String> participants,
    String about,
    String meetingTime,
    String meetingDate,
    String link,
  ) async {
    try {
      isLoading.value = true;
      final input = ScheduleMeetingModel(
        participants: participants,
        about: about,
        meeting_time: meetingTime,
        meeting_date: meetingDate,
        link: link,
      );

      final apiresponse = await ApiServices.scheduledMeeting(input.toJson());
      print(" Schedule meeting Apiresponse: $apiresponse");
      Get.snackbar('Success', 'Meeting scheduled successfully');
    } catch (e) {
      print("Error $e");
      Get.snackbar('Error', 'Failed to schedule meeting: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
