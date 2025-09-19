import 'package:get/get.dart';
import 'package:message_notifier/core/services/api_services.dart';
import 'package:message_notifier/features/employees/model/project_list_model.dart';

class ProjectListController extends GetxController {
  var isLoading = false.obs;
  var projectname = <String>[].obs;
  var projectid = <int>[].obs;

  Future<void> fetchProjectList() async {
    try {
      isLoading.value = true;
      final apiresponse = await ApiServices.projectList();
      projectname.clear();
      projectid.clear();
      for (ProjectListModel project in apiresponse) {
        projectname.add(project.name);
        projectid.add(project.id);
      }
      print("Project Names: $projectname");
      print("Project IDs: $projectid");
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading.value = false;
    }
  }
}
