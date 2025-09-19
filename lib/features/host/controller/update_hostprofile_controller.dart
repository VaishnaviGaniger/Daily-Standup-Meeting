import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/host/controller/host_profile_controller.dart';

class UpdateHostprofileController extends GetxController {
  final HostProfileController hostProfileController = Get.put(
    HostProfileController(),
  );
  var isLoading = false.obs;

  Future<void> updateProfile(Map<String, dynamic> updatedFields) async {
    try {
      isLoading.value = true;
      final apiresponse = await ApiServices.updatehostprofile(updatedFields);
      hostProfileController.hostProfile.value = apiresponse;
    } catch (e) {
      print("Error");
      // Get.snackbar("Error", "Failed to update profile: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
