import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/core/services/shared_prefs_service.dart';
import 'package:message_notifier/features/auth/model/register_request_model.dart';

class RegisterScreenController extends GetxController {
  var isLoading = false.obs;

  Future<void> register(
    String username,
    String email,
    String password,
    // String confirmpassword,
    String phone,
    String address,
    String dob,
    String designation,
    // String role,
  ) async {
    try {
      isLoading.value = true;
      final input = RegisterRequestModel(
        username: username,
        email: email,
        password: password,
        //confirmpassword: confirmpassword,
        phone: phone,
        address: address,
        dob: dob,
        designation: designation,
        // role: role,
        // fcmToken: fcmToken ?? 'fcm token',
      );
      final registerData = await ApiServices().register(input.toJson());
      final String token = registerData['token'];
      print("Token Data : $token");
      await SharedPrefsService.saveToken(token);

      print("RegisterInfo: $registerData");
      Get.back();
      print("Register Data $registerData");
      return registerData;
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading.value = false;
    }
  }
}
