import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/features/employees/controller/project_list_controller.dart';
import 'package:message_notifier/features/employees/controller/submit_daily_task_controller.dart';
import 'package:message_notifier/features/common_model/submit_daily_tasks_model.dart';

class SubmitDailyTaskEmpScreen extends StatefulWidget {
  const SubmitDailyTaskEmpScreen({super.key});

  @override
  State<SubmitDailyTaskEmpScreen> createState() =>
      _SubmitDailyTaskEmpScreenState();
}

class _SubmitDailyTaskEmpScreenState extends State<SubmitDailyTaskEmpScreen> {
  final ProjectListController _projectListController = Get.put(
    ProjectListController(),
  );
  final SubmitDailyTaskEmpController submitDailyTasksController = Get.put(
    SubmitDailyTaskEmpController(),
  );

  final List<List<ProjectSection>> _pageProjectSections = [
    [ProjectSection()], // Yesterday’s tasks
    [ProjectSection()], // Today’s plans
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  final TextEditingController blockersController = TextEditingController();
  int? blockerProject;

  // --------- cutoff lockout -------------
  bool _lockedOut = false;

  void _checkCutoff() {
    final now = DateTime.now();
    final cutoff = DateTime(now.year, now.month, now.day, 10, 30); // 10:30 AM
    if (now.isAfter(cutoff)) {
      _lockedOut = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.defaultDialog(
          title: "Submissions closed",
          titleStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.rich_teal,
          ),
          middleText: "It's past 10:30 AM. You should submit before 10:30 AM.",
          textConfirm: "OK",
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back(); // close dialog
            Navigator.of(context).pop(); // leave this page
          },
          barrierDismissible: false,
          buttonColor: const Color(0xFF2E8B7F),
          radius: 10,
        );
      });
    }
  }
  // --------------------------------------

  @override
  void initState() {
    super.initState();
    _checkCutoff();
    if (!_lockedOut) {
      _projectListController.fetchProjectList();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    blockersController.dispose();
    super.dispose();
  }

  String convertToTimeFormat(String input) {
    double hours = double.tryParse(input) ?? 0.0;
    int hr = hours.floor();
    int min = ((hours - hr) * 60).round();
    return "${hr.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}";
  }

  bool _sectionHasAnyTask(List<ProjectSection> sections) {
    // A section counts only if a project is selected AND any task has non-empty text
    for (final s in sections) {
      if (s.selectedProject != null) {
        final hasText = s.controllersy.any((c) => c.text.trim().isNotEmpty);
        if (hasText) return true;
      }
    }
    return false;
  }

  void _showRequiredPopup(String title, String message) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        color: AppColors.rich_teal,
      ),
      middleText: message,
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
      buttonColor: const Color(0xFF2E8B7F),
      radius: 10,
    );
  }

  bool _validateRequiredPages() {
    final hasYesterday = _sectionHasAnyTask(_pageProjectSections[0]);
    final hasToday = _sectionHasAnyTask(_pageProjectSections[1]);

    if (!hasYesterday || !hasToday) {
      final missingPage = !hasYesterday ? 0 : 1;
      _pageController.animateToPage(
        missingPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      _showRequiredPopup(
        "Add required updates",
        !hasYesterday && !hasToday
            ? "Please add at least one project and task in both:\n• Yesterday's Tasks\n• Today's Plans"
            : !hasYesterday
            ? "Please add at least one project and task in Yesterday's Tasks."
            : "Please add at least one project and task in Today's Plans.",
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Short-circuit UI if locked out (dialog is already shown and page will pop)
    if (_lockedOut) {
      return const Scaffold(backgroundColor: Colors.white);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),
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
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _currentPage == 0
                            ? "Yesterday's Tasks"
                            : _currentPage == 1
                            ? "Today's Plans"
                            : "Blockers & Challenges",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    Obx(
                      () => submitDailyTasksController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const SizedBox(width: 28),
                    ),
                  ],
                ),
              ),

              // --- 🔔 Alert Message Section ---
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade700, width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Daily task submission closes at 10:30 AM.",
                        style: TextStyle(
                          color: AppColors.note_color,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PageView
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                  ),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 3,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, pageIndex) {
                      return Obx(() {
                        if (_projectListController.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF2E8B7F),
                            ),
                          );
                        }

                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Column(
                              key: ValueKey(pageIndex),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (pageIndex == 2)
                                  _buildBlockersSection()
                                else
                                  _buildTasksSection(pageIndex),
                                const SizedBox(height: 20),
                                _buildGradientButton(
                                  label: pageIndex == 2 ? "Submit" : "Next",
                                  icon: pageIndex == 2
                                      ? Icons.check_circle_outline
                                      : Icons.arrow_forward_rounded,
                                  onPressed: () async {
                                    if (pageIndex < 2) {
                                      _pageController.nextPage(
                                        duration: const Duration(
                                          milliseconds: 400,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    } else {
                                      // ✅ Require Yesterday & Today
                                      if (!_validateRequiredPages()) return;

                                      final model = SubmitDailyUpdatesModel(
                                        // keep only rows with a project selected AND at least one non-empty task
                                        yesterday: _pageProjectSections[0]
                                            .where(
                                              (s) =>
                                                  s.selectedProject != null &&
                                                  s.controllersy.any(
                                                    (c) => c.text
                                                        .trim()
                                                        .isNotEmpty,
                                                  ),
                                            )
                                            .map(
                                              (s) => YesterdayTask(
                                                projectId:
                                                    s.selectedProject ?? 0,
                                                // keep only non-empty tasks
                                                tasks: List.generate(
                                                  s.controllersy.length,
                                                  (i) {
                                                    final desc = s
                                                        .controllersy[i]
                                                        .text
                                                        .trim();
                                                    if (desc.isEmpty) {
                                                      return null;
                                                    }
                                                    return Task(
                                                      description: desc,
                                                      time: convertToTimeFormat(
                                                        s
                                                            .timeControllers[i]
                                                            .text,
                                                      ),
                                                      status: s.statusList[i],
                                                    );
                                                  },
                                                ).whereType<Task>().toList(),
                                              ),
                                            )
                                            .toList(),

                                        today: _pageProjectSections[1]
                                            .where(
                                              (s) =>
                                                  s.selectedProject != null &&
                                                  s.controllersy.any(
                                                    (c) => c.text
                                                        .trim()
                                                        .isNotEmpty,
                                                  ),
                                            )
                                            .map(
                                              (s) => TodayTask(
                                                projectId:
                                                    s.selectedProject ?? 0,
                                                tasks: List.generate(
                                                  s.controllersy.length,
                                                  (i) {
                                                    final desc = s
                                                        .controllersy[i]
                                                        .text
                                                        .trim();
                                                    if (desc.isEmpty) {
                                                      return null;
                                                    }
                                                    return Task(
                                                      description: desc,
                                                      time: convertToTimeFormat(
                                                        s
                                                            .timeControllers[i]
                                                            .text,
                                                      ),
                                                      status: s.statusList[i],
                                                    );
                                                  },
                                                ).whereType<Task>().toList(),
                                              ),
                                            )
                                            .toList(),

                                        // 🔓 Blockers stay optional
                                        blockers:
                                            (blockerProject != null &&
                                                blockersController.text
                                                    .trim()
                                                    .isNotEmpty)
                                            ? Blocker(
                                                projectId: blockerProject
                                                    .toString(),
                                                description: blockersController
                                                    .text
                                                    .trim(),
                                              )
                                            : Blocker(
                                                projectId: "",
                                                description: "",
                                              ),
                                      );

                                      await submitDailyTasksController
                                          .submitDailyUpdates(model);
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ),

              // Page Indicator
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final isActive = _currentPage == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: isActive ? 22 : 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF2E8B7F)
                          : Colors.white70,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: const Color(0xFF2E8B7F).withOpacity(0.5),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlockersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              "  Any Blockers?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.rich_teal,
              ),
            ),
            SizedBox(width: 6),
            Text("(Optional)", style: TextStyle(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: _boxStyle(),
          child: SizedBox(
            width: 250,
            child: DropdownButtonFormField<int>(
              initialValue: blockerProject,
              decoration: _inputDecoration('Select Project'),
              items: _projectListController.projectname
                  .asMap()
                  .entries
                  .map(
                    (entry) => DropdownMenuItem<int>(
                      value: _projectListController.projectid[entry.key],
                      child: Text(
                        _projectListController.projectname[entry.key],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => blockerProject = value),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: _boxStyle(),
          child: TextFormField(
            controller: blockersController,
            decoration: _inputDecoration(
              "Describe any blockers or issues you faced",
            ),
            maxLines: null,
            minLines: 3,
            keyboardType: TextInputType.multiline,
          ),
        ),
      ],
    );
  }

  Widget _buildTasksSection(int pageIndex) {
    return Column(
      children: [
        for (int i = 0; i < _pageProjectSections[pageIndex].length; i++)
          _buildProjectSection(pageIndex, i),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            setState(() {
              _pageProjectSections[pageIndex].add(ProjectSection());
            });
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF2E8B7F),
            side: const BorderSide(color: Color(0xFF2E8B7F)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.add_circle_outline, size: 18),
          label: const Text(
            "Add Another Project",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectSection(int pageIndex, int sectionIndex) {
    final section = _pageProjectSections[pageIndex][sectionIndex];
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: _boxStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 250,
                child: DropdownButtonFormField<int>(
                  initialValue: section.selectedProject,
                  decoration: _inputDecoration('Select Project'),
                  items: _projectListController.projectname
                      .asMap()
                      .entries
                      .map(
                        (entry) => DropdownMenuItem<int>(
                          value: _projectListController.projectid[entry.key],
                          child: Text(
                            _projectListController.projectname[entry.key],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => section.selectedProject = value),
                ),
              ),
              if (_pageProjectSections[pageIndex].length > 1)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  onPressed: () => setState(
                    () =>
                        _pageProjectSections[pageIndex].removeAt(sectionIndex),
                  ),
                ),
            ],
          ),
          Divider(color: Colors.grey.shade300, thickness: 0.8),
          const SizedBox(height: 8),
          for (
            int taskIndex = 0;
            taskIndex < section.controllersy.length;
            taskIndex++
          )
            Column(
              children: [
                _buildTaskEntry(pageIndex, section, taskIndex),
                if (taskIndex != section.controllersy.length - 1)
                  Divider(color: Colors.grey[300], thickness: 0.6),
              ],
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  section.controllersy.add(TextEditingController());
                  section.timeControllers.add(
                    TextEditingController(text: '1.0'),
                  );
                  section.statusList.add("pending");
                });
              },
              icon: const Icon(Icons.add, size: 16, color: Color(0xFF2E8B7F)),
              label: const Text(
                "Add Task",
                style: TextStyle(
                  color: Color(0xFF2E8B7F),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskEntry(int pageIndex, ProjectSection section, int taskIndex) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        children: [
          TextFormField(
            controller: section.controllersy[taskIndex],
            decoration: _inputDecoration("Task Description").copyWith(
              suffixIcon: section.controllersy.length > 1
                  ? IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          section.controllersy.removeAt(taskIndex);
                          section.timeControllers.removeAt(taskIndex);
                          section.statusList.removeAt(taskIndex);
                        });
                      },
                    )
                  : null,
            ),
            maxLines: null, // expands dynamically
            minLines: 1,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 6),
          _buildTimeAndStatus(section, taskIndex),
        ],
      ),
    );
  }

  Widget _buildTimeAndStatus(ProjectSection section, int taskIndex) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: section.timeControllers[taskIndex],
            readOnly: true,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: _inputDecoration("Time (hrs)").copyWith(
              suffixIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      double current =
                          double.tryParse(
                            section.timeControllers[taskIndex].text,
                          ) ??
                          1.0;
                      setState(() {
                        current += 0.5;
                        section.timeControllers[taskIndex].text = current
                            .toStringAsFixed(1);
                      });
                    },
                    child: const Icon(
                      Icons.arrow_drop_up,
                      color: Color(0xFF2E8B7F),
                      size: 20,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      double current =
                          double.tryParse(
                            section.timeControllers[taskIndex].text,
                          ) ??
                          1.0;
                      if (current > 0.5) {
                        setState(() {
                          current -= 0.5;
                          section.timeControllers[taskIndex].text = current
                              .toStringAsFixed(1);
                        });
                      }
                    },
                    child: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF2E8B7F),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: section.statusList[taskIndex],
            decoration: _inputDecoration("Status"),
            items: const [
              DropdownMenuItem(value: "pending", child: Text("Pending")),
              DropdownMenuItem(value: "completed", child: Text("Completed")),
            ],
            onChanged: (val) =>
                setState(() => section.statusList[taskIndex] = val!),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: const Color(0xFF2E8B7F),
          shadowColor: const Color(0xFF2E8B7F).withOpacity(0.4),
        ),
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Color(0xFF2E8B7F),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF2E8B7F), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF2E8B7F), width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );

  BoxDecoration _boxStyle() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade200,
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

class ProjectSection {
  int? selectedProject;
  List<TextEditingController> controllersy = [TextEditingController()];
  List<TextEditingController> timeControllers = [
    TextEditingController(text: '1.0'),
  ];
  List<String> statusList = ["pending"];
}
