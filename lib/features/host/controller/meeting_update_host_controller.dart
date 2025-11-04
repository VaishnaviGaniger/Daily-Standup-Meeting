import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/employees/model/meetings_update_model.dart';

class MeetingUpdateHostController extends GetxController {
  var isLoading = false.obs;
  var meetings = <MeetingsUpdateModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    meetingupdates();
  }

  Future<void> meetingupdates() async {
    try {
      isLoading.value = true;
      final apiresponse = await ApiServices.meetingupdateHost();
      meetings.value = apiresponse;
      //  .where((m) => m.isCancel == false || m.isCancel == null)
      //    .toList();
      print("meeting updates $meetings");
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading.value = false;
    }
  }
}
