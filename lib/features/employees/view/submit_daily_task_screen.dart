// submit_daily_task_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/features/employees/controller/project_list_controller.dart';
import 'package:message_notifier/features/employees/controller/submit_daily_task_controller.dart';
import 'package:message_notifier/features/employees/model/submit_daily_task.dart';
import 'package:duration_picker/duration_picker.dart';

class SubmitDailyTaskScreen extends StatefulWidget {
  const SubmitDailyTaskScreen({super.key});

  @override
  State<SubmitDailyTaskScreen> createState() => _SubmitDailyTaskScreenState();
}

class _SubmitDailyTaskScreenState extends State<SubmitDailyTaskScreen> {
  final ProjectListController _projectListController = Get.put(
    ProjectListController(),
  );
  final SubmitDailyTaskController _submitDailyTaskController = Get.put(
    SubmitDailyTaskController(),
  );

  final List<ProjectSection> _projectSections = [];

  @override
  void initState() {
    super.initState();
    _projectListController.fetchProjectList();
    _projectSections.add(ProjectSection());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E8B7F), Color(0xFF1F5F5B), Color(0xFF0D4F47)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        "Submit Daily Task",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Obx(
                      () => _submitDailyTaskController.isLoading.value
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const SizedBox(width: 22),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Obx(
                  () => _projectListController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              for (
                                int sectionIndex = 0;
                                sectionIndex < _projectSections.length;
                                sectionIndex++
                              )
                                _buildProjectSection(sectionIndex),

                              const SizedBox(height: 10),

                              // Add project button
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _projectSections.add(ProjectSection());
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                ),
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Add Another Project",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Submit button
                              _buildGradientButton(
                                label: "Submit All Tasks",
                                icon: Icons.send,
                                onPressed: _submitTasks,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectSection(int sectionIndex) {
    final section = _projectSections[sectionIndex];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with remove button
          Row(
            children: [
              Text(
                "Project ${sectionIndex + 1}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E8B7F),
                ),
              ),
              const Spacer(),
              if (_projectSections.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    setState(() {
                      _projectSections.removeAt(sectionIndex);
                    });
                  },
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Project dropdown
          DropdownButtonFormField<int>(
            value: section.selectedProject,
            decoration: InputDecoration(
              labelText: 'Select Project',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            items: _projectListController.projectname
                .asMap()
                .entries
                .map(
                  (entry) => DropdownMenuItem<int>(
                    value: _projectListController.projectid[entry.key],
                    child: Text(_projectListController.projectname[entry.key]),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                section.selectedProject = value;
              });
            },
          ),

          const SizedBox(height: 16),

          // Task entries
          for (
            int taskIndex = 0;
            taskIndex < section.controllers.length;
            taskIndex++
          )
            _buildTaskEntry(section, sectionIndex, taskIndex),

          // Add task button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  section.controllers.add(TextEditingController());
                  section.dateTimes.add(DateTime.now());
                });
              },
              icon: const Icon(Icons.add, size: 18, color: Color(0xFF2E8B7F)),
              label: const Text(
                "Add Task",
                style: TextStyle(
                  color: Color(0xFF2E8B7F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskEntry(
    ProjectSection section,
    int sectionIndex,
    int taskIndex,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              controller: section.controllers[taskIndex],
              decoration: InputDecoration(
                labelText: "Task description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                suffixIcon: section.controllers.length > 1
                    ? IconButton(
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            section.controllers.removeAt(taskIndex);
                            section.dateTimes.removeAt(taskIndex);
                          });
                        },
                      )
                    : null,
              ),
              maxLines: 2,
            ),
          ),
          const SizedBox(width: 12),

          // Time picker
          SizedBox(
            width: 120,
            child: InkWell(
              onTap: () => _selectDateTime(section, taskIndex),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: "Time spent",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    _formatTime(section.dateTimes[taskIndex]),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateTime(ProjectSection section, int taskIndex) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(section.dateTimes[taskIndex]),
    );

    if (pickedTime != null) {
      setState(() {
        final newDateTime = DateTime(
          section.dateTimes[taskIndex].year,
          section.dateTimes[taskIndex].month,
          section.dateTimes[taskIndex].day,
          pickedTime.hour,
          pickedTime.minute,
        );
        section.dateTimes[taskIndex] = newDateTime;
      });
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _submitTasks() {
    List<SubmitDailyTaskModel> tasks = [];

    for (int i = 0; i < _projectSections.length; i++) {
      final section = _projectSections[i];
      final projectId = section.selectedProject;

      if (projectId == null) {
        Get.snackbar(
          'Error',
          'Please select a project for all sections',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      for (int j = 0; j < section.controllers.length; j++) {
        if (section.controllers[j].text.isEmpty) {
          Get.snackbar(
            'Error',
            'Please enter task description for all tasks',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      final updates = section.controllers.map((c) => c.text).toList();
      final times = section.dateTimes.map(_formatTime).toList();
      final status = List<String>.filled(updates.length, "completed");

      tasks.add(
        SubmitDailyTaskModel(
          project: projectId,
          status: status,
          tasks_project: updates,
          time_taken: times,
        ),
      );
    }

    _submitDailyTaskController.dailyTask(tasks);
  }

  Widget _buildGradientButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E8B7F), Color(0xFF1F5F5B)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E8B7F).withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class ProjectSection {
  int? selectedProject;
  List<TextEditingController> controllers;
  List<DateTime> dateTimes;

  ProjectSection()
    : selectedProject = null,
      controllers = [TextEditingController()],
      dateTimes = [DateTime.now()];
}
