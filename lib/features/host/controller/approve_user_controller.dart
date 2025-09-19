import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/host/model/approved_user_model.dart';
import 'package:message_notifier/features/host/model/requesting_user_model.dart';

class ApproveUserController extends GetxController {
  var isLoading = false.obs;
  var employee = <RequestingUserModel>[].obs;

  var usernames = <String>[].obs;
  var userid = <int>[].obs;

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
        "Success",
        "User approved successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
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
    //  bool is_approved
  ) async {
    try {
      isLoading.value = true;
      // final input = RejectUserModel(is_approved: is_approved);
      final apiResponse = await ApiServices.rejectUser(
        id,
        // input.toJson()
      );
      print("Api Response: $apiResponse");
      employee.removeWhere((emp) => emp.id == id);
    } catch (e) {
      print("Error");
    } finally {
      isLoading.value = false;
    }
  }
}
