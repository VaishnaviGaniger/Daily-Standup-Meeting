import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/host/model/approve_user_model.dart';

class ApprovedUserController extends GetxController {
  var isLoading = false.obs;
  var employee = <ApproveUserModel>[].obs;

  var usernames = <String>[].obs;
  var userid = <int>[].obs;

  Future<void> approvedUser() async {
    try {
      isLoading.value = true;
      List<ApproveUserModel> apiResponse = await ApiServices.approvedUser();
      employee.assignAll(apiResponse);
      // print(apiResponse);
      usernames.clear();
      for (var emp in employee) {
        usernames.add(emp.username);
      }
      // print("Approve user $usernames");
      userid.clear();
      for (var emp in employee) {
        userid.add(emp.id);
      }
      print("Usernames : $usernames");
      print("User Id: $userid");
    } catch (e) {
      usernames.clear();
      print("Error in approveUser: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
