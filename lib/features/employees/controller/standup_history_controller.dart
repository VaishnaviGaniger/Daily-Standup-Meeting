import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/employees/model/standup_history_model.dart';

class StandupHistoryController extends GetxController {
  var isLoading = false.obs;
  var history = <StandupHistoryModel>[].obs;

  Future<void> standupHistory() async {
    try {
      isLoading.value = true;
      final apiresponse = await ApiServices.standuphistory();

      history.assignAll(apiresponse);
      print("StandUp History $history");
    } catch (e) {
      throw 'error';
    } finally {
      isLoading.value = false;
    }
  }
}
