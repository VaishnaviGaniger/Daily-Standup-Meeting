import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/employees/controller/emp_profile_controller.dart';

class UpdateEmployeeProfileController extends GetxController {
  final EmpProfileController empProfileController = Get.put(
    EmpProfileController(),
  );
  var isLoading = false.obs;

  Future<void> updateProfile(Map<String, dynamic> updatedFields) async {
    try {
      isLoading.value = true;
      final apiresponse = await ApiServices.updatehostprofile(updatedFields);
      empProfileController.profile.value = apiresponse;
    } catch (e) {
      print("Error");
    } finally {
      isLoading.value = false;
    }
  }
}
