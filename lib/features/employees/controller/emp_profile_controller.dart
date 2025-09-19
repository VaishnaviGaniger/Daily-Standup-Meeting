import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/employees/model/emp_profile_model.dart';

class EmpProfileController extends GetxController {
  var isLoading = false.obs;
  var profile = Rxn<EmpProfileModel>();

  Future<void> fetchprofile() async {
    try {
      isLoading.value = true;
      final apiresponse = await ApiServices.empprofile();
      if (apiresponse != null) {
        profile.value = apiresponse;
      }
      profile.value = apiresponse;
    } catch (e) {
      print("❌ API Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
