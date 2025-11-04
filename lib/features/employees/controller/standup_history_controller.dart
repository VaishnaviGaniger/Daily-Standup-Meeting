import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/employees/model/standup_history_model.dart';

class StandupHistoryController extends GetxController {
  var isLoading = false.obs;
  var history = Rxn<StandupHistoryModel>();

  Future<void> fetchStandupHistory({DateTime? date}) async {
    try {
      isLoading.value = true;

      // If no date passed, use today’s date
      final selectedDate = DateFormat(
        'yyyy-MM-dd',
      ).format(date ?? DateTime.now());

      print("📅 Fetching standup data for: $selectedDate");

      final apiResponse = await ApiServices.standupHistory(date: selectedDate);

      history.value = apiResponse;
    } catch (e) {
      print("❌ Error fetching standup history: $e");
      history.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
