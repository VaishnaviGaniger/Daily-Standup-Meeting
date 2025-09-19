import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/host/model/requesting_user_model.dart';

class RequestedUsersController extends GetxController {
  var isLoading = false.obs;
  var username = <RequestingUserModel>[].obs;

  Future<void> requestData() async {
    try {
      isLoading.value = true;
      final apiresponse = await ApiServices.requestingUserData();
      username.assignAll(apiresponse);
    } catch (e) {
      throw Exception("Error");
    } finally {
      isLoading.value = false;
    }
  }
}
