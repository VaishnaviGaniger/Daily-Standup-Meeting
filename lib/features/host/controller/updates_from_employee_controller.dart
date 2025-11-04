import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/host/model/updates_from_employee.dart';

class AllTasksUpdatesController extends GetxController {
  var isLoading = false.obs;
  var allTasksUpdatesList = <AllTasksUpdatesModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllTasksUpdates();
  }

  Future<void> fetchAllTasksUpdates() async {
    try {
      isLoading.value = true;
      print("🔄 Fetching all tasks updates...");

      final response = await ApiServices.allTasksUpdates();
      allTasksUpdatesList.value = List<AllTasksUpdatesModel>.from(response);

      print("✅ All Tasks Updates Loaded Successfully");
      print("Total Dates Fetched: ${response.length}");
    } catch (e) {
      print("❌ Error fetching All Tasks Updates: $e");
      Get.snackbar(
        'Error',
        'Failed to load tasks updates',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
