import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/host/model/approved_user_model.dart';
import 'package:message_notifier/features/host/model/requesting_user_model.dart';

class ApproveUserController extends GetxController {
  var isLoading = false.obs;
  var employee = <RequestingUserModel>[].obs;

  var usernames = <String>[].obs;
  var userid = <int>[].obs;

  //  void updateUserRole(int index, String? role) {
  //   if (index >= 0 && index < employee.length) {
  //     employee[index].selectedRole = role;
  //     employee.refresh(); // This triggers UI update
  //   }
  // }

  Future<void> requestingUserData() async {
    try {
      isLoading.value = true;
      List<RequestingUserModel> apiResponse =
          await ApiServices.requestingUserData();
      employee.assignAll(apiResponse);
      print(apiResponse);
      usernames.clear();
      for (var emp in employee) {
        usernames.add(emp.username);
      }
      userid.clear();
      for (var emp in employee) {
        userid.add(emp.id);
      }
      print("Usernames: $usernames");
      print("User Id: $userid");
    } catch (e) {
      print("Error in approveUser: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approveUser(int id, String role) async {
    // var usernames = <String>[].obs;
    // var userid = <int>[].obs;
    try {
      isLoading.value = true;
      final input = ApprovedUserModel(role: role);
      final apiResponse = await ApiServices.approveUser(id, input.toJson());
      print(" Response approved : $apiResponse");
      Get.snackbar(
        "✅ Success",
        "User approved successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: AppColors.white,
        margin: EdgeInsets.all(12),
        borderRadius: 10,
        duration: Duration(seconds: 2),
      );

      // optional: remove user from list after approval
      employee.removeWhere((emp) => emp.id == id);
      // employee.removeAt(index);
    } catch (e) {
      print("Error from here");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectUser(
    int id,
    // int index
  ) async {
    try {
      isLoading.value = true;
      // final input = RejectUserModel(is_approved: is_approved);
      final apiResponse = await ApiServices.rejectUser(id);
      //   if (index >= 0 && index < employee.length) {
      //   employee.removeAt(index);
      // }

      employee.removeWhere((emp) => emp.id == id);
      employee.refresh(); // force UI refresh if needed
      print("Api Response: $apiResponse");
      Get.snackbar(
        "❌ Rejected",
        "User rejected successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color.fromARGB(200, 224, 78, 68),
        colorText: AppColors.white,
        margin: EdgeInsets.all(12),
        borderRadius: 10,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      print("Error in rejectUser: $e");
      Get.snackbar(
        "❌ Error",
        "Failed to reject user",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: AppColors.white,
        margin: EdgeInsets.all(12),
        borderRadius: 10,
        duration: Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
