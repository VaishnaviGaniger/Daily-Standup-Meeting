import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/features/employees/controller/project_list_controller.dart';
import 'package:message_notifier/features/host/controller/approved_user_controller.dart';

class AssignTasksScreen extends StatefulWidget {
  const AssignTasksScreen({super.key});

  @override
  State<AssignTasksScreen> createState() => _AssignTasksScreenState();
}

class _AssignTasksScreenState extends State<AssignTasksScreen> {
  final ProjectListController _projectListController =
      Get.isRegistered<ProjectListController>()
      ? Get.find<ProjectListController>()
      : Get.put(ProjectListController(), permanent: true);

  final ApprovedUserController _approvedUserController =
      Get.isRegistered<ApprovedUserController>()
      ? Get.find<ApprovedUserController>()
      : Get.put(ApprovedUserController(), permanent: true);

  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedProject;
  String? _selectedEmployee;

  @override
  void initState() {
    super.initState();
    _projectListController.fetchProjectList();
    _approvedUserController.approvedUser();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_selectedProject == null ||
        _descriptionController.text.trim().isEmpty ||
        _selectedEmployee == null) {
      Get.snackbar(
        "Missing Information",
        "Please fill out all fields before submitting.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: AppColors.rich_teal,
      );
      return;
    }

    // Placeholder: add your logic to assign the task here
    Get.snackbar(
      "Success",
      "Task assigned successfully!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: AppColors.rich_teal,
    );

    setState(() {
      _selectedProject = null;
      _selectedEmployee = null;
      _descriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.rich_teal,
      appBar: AppBar(
        title: const Text(
          "Assign Task",
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.rich_teal,
        // backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.rich_teal, Color(0xFF1F5F5B), Color(0xFF0D4F47)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProjectDropdown(),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  style: const TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    labelText: "Task Description",
                    labelStyle: const TextStyle(color: AppColors.white),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: AppColors.white.withOpacity(0.15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.whiteLogin),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: AppColors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                _buildEmployeeDropdown(),
                const SizedBox(height: 40),

                ElevatedButton.icon(
                  onPressed: _onSubmit,
                  icon: const Icon(Icons.send, color: Color(0xFF0D4F47)),
                  label: const Text(
                    "Assign Task",
                    style: TextStyle(
                      color: AppColors.dark_teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectDropdown() {
    return Obx(() {
      if (_projectListController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.white),
        );
      }

      return DropdownButtonFormField<String>(
        initialValue: _selectedProject,
        decoration: InputDecoration(
          labelText: "Select Project",
          labelStyle: const TextStyle(color: AppColors.white),
          filled: true,
          fillColor: AppColors.white.withOpacity(0.15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.whiteLogin),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: AppColors.white),
          ),
        ),
        dropdownColor: Colors.white,
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.white),
        items: _projectListController.projectList
            .map(
              (project) => DropdownMenuItem<String>(
                value: project.name,
                child: Text(
                  project.name,
                  style: const TextStyle(
                    color: AppColors.rich_teal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (value) => setState(() => _selectedProject = value),
      );
    });
  }

  Widget _buildEmployeeDropdown() {
    return Obx(() {
      if (_approvedUserController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.white),
        );
      }

      return DropdownButtonFormField<String>(
        initialValue: _selectedEmployee,
        decoration: InputDecoration(
          labelText: "Assign to Employee",
          labelStyle: const TextStyle(color: AppColors.white),
          filled: true,
          fillColor: AppColors.white.withOpacity(0.15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.whiteLogin),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: AppColors.white),
          ),
        ),
        dropdownColor: Colors.white,
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.white),
        items: _approvedUserController.employee
            .map(
              (employee) => DropdownMenuItem<String>(
                value: employee.username,
                child: Text(
                  employee.username,
                  style: const TextStyle(
                    color: AppColors.rich_teal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (value) => setState(() => _selectedEmployee = value),
      );
    });
  }
}
