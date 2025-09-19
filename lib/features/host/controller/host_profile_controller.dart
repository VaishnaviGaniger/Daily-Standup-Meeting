import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/host/model/host_profile_model.dart';

class HostProfileController extends GetxController {
  var isLoading = false.obs;
  var hostProfile = Rxn<HostProfileModel>();
  var errorMessage = ''.obs;

  Future<void> getHostProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final apiResponse = await ApiServices.hostProfile();

      if (apiResponse != null) {
        print(apiResponse);
        hostProfile.value = apiResponse;
      } else {
        Get.snackbar('Error', 'Failed to load profile data');
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
