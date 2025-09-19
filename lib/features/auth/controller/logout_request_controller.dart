import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/core/services/shared_prefs_service.dart';
import 'package:message_notifier/features/auth/view/login_screen.dart';

class LogoutRequestController extends GetxController {
  var isLoading = false.obs;

  Future<void> logout() async {
    try {
      isLoading.value = true;
      final apiresponse = await ApiServices.logout();
      print("Logout apiresponse : $apiresponse");
      if (apiresponse!["message"] == "Logged out successfully") {
        await SharedPrefsService.removeToken();
        Get.snackbar("Logout successfully", "");
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => LoginScreen()),
        // );
        Get.to(LoginScreen());
      } else {
        print("Error");
        //Get.snackbar("Logout Failed", apiresponse["error"] ?? "Unknown error");
      }
    } catch (e) {
      print("Error $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
