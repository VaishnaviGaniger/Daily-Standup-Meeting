import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/features/host/controller/approve_user_controller.dart';

class ApprovalPendingScreen extends StatefulWidget {
  const ApprovalPendingScreen({super.key});

  @override
  State<ApprovalPendingScreen> createState() => _ApprovalPendingState();
}

class _ApprovalPendingState extends State<ApprovalPendingScreen> {
  final ApproveUserController _approveUserController = Get.put(
    ApproveUserController(),
  );

  @override
  void initState() {
    super.initState();
    _approveUserController.requestingUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Approval Pending request",
          style: TextStyle(
            fontSize: 20,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.rich_teal,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              AppColors.rich_teal,
              AppColors.dark_teal,
              AppColors.darkest_teal,
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              left: 16.0,
              right: 16.0,
            ), // Top padding for safety
            child: Obx(() {
              if (_approveUserController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.white),
                );
              }

              return ListView.builder(
                itemCount: _approveUserController.employee.length,
                itemBuilder: (context, index) {
                  final user = _approveUserController.employee[index];

                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ), // Reduced bottom spacing
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // Tighter radius
                      ),
                      elevation:
                          4, // Slightly less elevation for a flatter look
                      color: AppColors.white,
                      // Reduced inner padding
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize:
                              MainAxisSize.min, // Make the container minimal
                          children: [
                            // 1. Username and Role Selection (in one row)
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 18, // Smaller avatar
                                  backgroundColor: AppColors.rich_teal,
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.white,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    user.username,
                                    style: const TextStyle(
                                      fontSize: 16, // Slightly smaller font
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Role Dropdown (Compact)
                                SizedBox(
                                  width: 120, // Fixed width for compactness
                                  child: DropdownButtonFormField<String>(
                                    initialValue: user.selectedRole,
                                    hint: const Text(
                                      "Role",
                                      style: TextStyle(fontSize: 13),
                                    ), // Smaller hint text
                                    isDense: true, // Make it more compact
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8, // Reduced padding
                                            vertical: 6,
                                          ),
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    items: ["lead", "employee"]
                                        .map(
                                          (role) => DropdownMenuItem(
                                            value: role,
                                            child: Text(
                                              role.capitalizeFirst!,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ), // Smaller option font
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        _approveUserController
                                                .employee[index]
                                                .selectedRole =
                                            value;
                                        _approveUserController.employee
                                            .refresh();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (user.selectedRole != null) {
                                        _approveUserController.approveUser(
                                          user.id,
                                          user.selectedRole.toString(),
                                        );
                                      } else {
                                        Get.snackbar(
                                          "Missing Role",
                                          "Please select a role before approving.",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor:
                                              Colors.amber.shade700,
                                          colorText: AppColors.white,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        86,
                                        196,
                                        92,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ), // Reduced vertical padding
                                      elevation: 2,
                                    ),
                                    child: const Text(
                                      "Approve",
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14, // Smaller font
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8), // Reduced spacing
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      await _approveUserController.rejectUser(
                                        user.id,
                                      );
                                      Get.snackbar(
                                        "❌ Rejected",
                                        "${user.username} rejected successfully",
                                        snackPosition: SnackPosition.TOP,
                                        backgroundColor: Colors.redAccent,
                                        colorText: AppColors.white,
                                        margin: EdgeInsets.all(12),
                                        borderRadius: 10,
                                        duration: Duration(seconds: 2),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: const Color.fromARGB(
                                          248,
                                          255,
                                          23,
                                          69,
                                        ),
                                        // width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ), // Reduced vertical padding
                                    ),
                                    child: Text(
                                      "Reject",
                                      style: TextStyle(
                                        color: Colors.redAccent.shade400,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14, // Smaller font
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
