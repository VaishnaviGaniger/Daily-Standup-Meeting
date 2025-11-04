// import 'package:get/get.dart';
// import 'package:message_notifier/core/services/api_services.dart';
// import 'package:message_notifier/features/employees/model/standup_history_model.dart';

// class StandupHistoryHostController extends GetxController {
//   var isLoading = false.obs;
//   var history = <StandupHistoryModel>[].obs;

//   Future<void> standuphistory() async {
//     try {
//       isLoading.value = true;
//       final apiresponse = await ApiServices.standupHistoryhost();
//       history.assignAll(apiresponse);
//     } catch (e) {
//       print(e);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
