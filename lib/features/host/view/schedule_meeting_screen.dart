import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/features/host/controller/approved_user_controller.dart';
import 'package:message_notifier/features/host/controller/schedule_meeting_controller.dart';

class ScheduleMeetingScreen extends StatefulWidget {
  const ScheduleMeetingScreen({super.key});

  @override
  State<ScheduleMeetingScreen> createState() => _ScheduleMeetingScreenState();
}

class _ScheduleMeetingScreenState extends State<ScheduleMeetingScreen> {
  List<String> selectedEmployees = [];
  bool isDropdownOpen = false;
  final ApprovedUserController _approvedUserController = Get.put(
    ApprovedUserController(),
  );
  final ScheduleMeetingController _scheduleMeetingController = Get.put(
    ScheduleMeetingController(),
  );
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController meetingtimeController = TextEditingController();
  final TextEditingController meetingdateeController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _approvedUserController.approvedUser();
  }

  @override
  Widget build(BuildContext context) {
    // print('Usernames list: ${_approvedUserController.usernames}');
    // print('Usernames length: ${_approvedUserController.usernames.length}');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daily Stand-up Meeting",
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.rich_teal, // Rich teal
              Color(0xFF1F5F5B), // Darker teal
              Color(0xFF0D4F47), // Deepest teal
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header section
                Text(
                  'Connect your team with purpose',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 25,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.rich_teal.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.schedule,
                                color: AppColors.rich_teal,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Meeting Details',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: AppColors.rich_teal,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24),

                        // Employee Selection Section
                        _buildEmployeeSelector(),

                        SizedBox(height: 20),

                        _buildInputField(
                          controller: aboutController,
                          label: "Meeting Topic",
                          hint: "What's this meeting about?",
                          icon: Icons.topic_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter meeting topic';
                            }
                            return null;
                          },
                          context: context,
                        ),

                        SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: _buildInputField(
                                controller: meetingdateeController,
                                label: "Date",
                                hint: "YYYY-MM-DD",
                                icon: Icons.calendar_today_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter date';
                                  }
                                  return null;
                                },
                                isDate: true,
                                context: context,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildInputField(
                                controller: meetingtimeController,
                                label: "Time",
                                hint: "HH:MM",
                                icon: Icons.access_time_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter time';
                                  }
                                  return null;
                                },
                                isTime: true,
                                context: context,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        _buildInputField(
                          controller: linkController,
                          label: "Meeting Link (Optional)",
                          hint: "Enter video call link",
                          icon: Icons.link_outlined,
                          context: context,
                        ),

                        SizedBox(height: 32),

                        // Action button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.rich_teal, Color(0xFF1F5F5B)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.rich_teal.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Obx(
                            () => _scheduleMeetingController.isLoading.value
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : ElevatedButton.icon(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (selectedEmployees.isEmpty) {
                                          Get.snackbar(
                                            'Error',
                                            'Please select at least one employee',
                                            backgroundColor: Colors.red[100],
                                            colorText: Colors.red[800],
                                          );
                                          return;
                                        }
                                        _scheduleMeetingController
                                            .schedulemeeting(
                                              selectedEmployees,
                                              aboutController.text,
                                              meetingtimeController.text,
                                              meetingdateeController.text,
                                              linkController.text,
                                            );
                                        Get.back();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.send_outlined,
                                      color: AppColors.white,
                                      size: 18,
                                    ),
                                    label: Text(
                                      "Schedule Meeting",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Bottom tip
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.white.withValues(alpha: 0.8),
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'All selected team members will receive a meeting notification',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.8),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Team Members',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),

        if (selectedEmployees.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.rich_teal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.rich_teal.withValues(alpha: 0.3),
              ),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedEmployees.map((employee) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.rich_teal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        employee,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedEmployees.remove(employee);
                          });
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 8),
        ],

        GestureDetector(
          onTap: () {
            setState(() {
              isDropdownOpen = !isDropdownOpen;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedEmployees.isEmpty
                      ? "Choose team members"
                      : "${selectedEmployees.length} member(s) selected",
                  style: TextStyle(
                    color: selectedEmployees.isEmpty
                        ? Colors.grey[400]
                        : Colors.grey[800],
                    fontSize: 16,
                  ),
                ),
                Icon(
                  isDropdownOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey[500],
                ),
              ],
            ),
          ),
        ),

        if (isDropdownOpen)
          Obx(
            () => Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ✅ Select All Checkbox
                  CheckboxListTile(
                    title: Text(
                      "Select All",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value:
                        selectedEmployees.length ==
                            _approvedUserController.usernames.length &&
                        _approvedUserController.usernames.isNotEmpty,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedEmployees = List.from(
                            _approvedUserController.usernames,
                          );
                        } else {
                          selectedEmployees.clear();
                        }
                      });
                      debugPrint("Selected Employees: $selectedEmployees");
                    },
                  ),
                  ...List.generate(_approvedUserController.usernames.length, (
                    index,
                  ) {
                    final name = _approvedUserController.usernames[index];
                    return Container(
                      decoration: BoxDecoration(
                        border:
                            index < _approvedUserController.usernames.length - 1
                            ? Border(
                                bottom: BorderSide(color: Colors.grey[200]!),
                              )
                            : null,
                      ),
                      child: CheckboxListTile(
                        title: Text(
                          name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                        value: selectedEmployees.contains(name),
                        activeColor: AppColors.rich_teal,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedEmployees.add(name);
                            } else {
                              selectedEmployees.remove(name);
                            }
                          });
                          debugPrint("Selected Employees: $selectedEmployees");
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    bool isDate = false,
    bool isTime = false,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            // color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextFormField(
            controller: controller,
            readOnly: isDate || isTime, // 👈 prevent typing
            style: TextStyle(color: Colors.grey[800], fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
              prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: validator,
            onTap: () async {
              if (isDate) {
                DateTime today = DateTime.now();
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: today,
                  firstDate: today,
                  lastDate: today,
                );
                if (pickedDate != null) {
                  controller.text =
                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                }
              } else if (isTime) {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  final now = DateTime.now();
                  final dt = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                  controller.text =
                      "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
