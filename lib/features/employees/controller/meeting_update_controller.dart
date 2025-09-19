import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/employees/model/meetings_update_model.dart';

class MeetingUpdateController extends GetxController {
  var isLoading = false.obs;
  final error = ''.obs;
  final meetings = <MeetingsUpdateModel>[].obs;

  Future<void> fetchMeetingupdates() async {
    try {
      isLoading.value = true;
      error.value = '';
      final List<MeetingsUpdateModel> apiresponse =
          await ApiServices.meetingUpdate();
      meetings.assignAll(apiresponse);
    } catch (e) {
      error.value = 'Failed to fetch $e';
      print("error $e");
    } finally {
      isLoading.value = false;
    }
  }
}
