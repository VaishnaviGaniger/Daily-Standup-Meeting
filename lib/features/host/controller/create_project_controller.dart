// import 'package:get/get.dart';
// import 'package:message_notifier/core/services/api_services.dart';
// import 'package:message_notifier/features/host/model/create_project_model.dart';

// class CreateProjectController extends GetxController {
//   var isLoading = false.obs;
//   // final storage = GetStorage(); //we can used this for larger data structure

//   Future<void> CreateProject(String name, String description) async {
//     try {
//       isLoading.value = true;
//       final input = CreateProjectModel(name: name, description: description);
//       final apiResponse = await ApiServices().createproject(input.toJson());
//       print("Response: $apiResponse");
//       // Get.to(HomePage());
//     } catch (e) {
//       // throw Exception('Error:$e');
//       print("Controller caught error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/host/model/create_project_model.dart';

class CreateProjectController extends GetxController {
  var isLoading = false.obs;

  Future<void> createproject(CreateProjectModel input) async {
    try {
      isLoading.value = true;
      final apiresponse = await ApiServices.createsProject(input.toJson());
      print("Response: $apiresponse");
      Get.snackbar("Project created Successfully", "");
      return apiresponse.data;
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading.value = false;
    }
  }
}
