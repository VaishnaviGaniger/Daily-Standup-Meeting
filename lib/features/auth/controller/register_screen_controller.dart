import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/auth/model/register_request_model.dart';
// import 'package:message_notifier/features/auth/model/role_model.dart';

class RegisterScreenController extends GetxController {
  var isLoading = false.obs;

  // List<RoleModel> roles = [
  //   RoleModel(value: 'employee', name: 'Employee'),
  //   RoleModel(value: 'lead', name: 'Tech Lead'),
  // ];
  // String? selectRole;

  @override
  void onInit() {
    super.onInit();
  }

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
      );
      final registerData = await ApiServices().register(input.toJson());
      print("RegisterInfo: $registerData");
      Get.back();
      print("Register Data $registerData");
      return registerData;

      // if(registerData['success'] == true){
      //   return true;

      // }else{
      //   return false;
      // }
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading.value = false;
    }
  }
}
