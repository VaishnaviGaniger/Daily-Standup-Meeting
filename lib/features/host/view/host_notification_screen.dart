import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/features/host/controller/approve_user_controller.dart';

class HostNotificationScreen extends StatefulWidget {
  const HostNotificationScreen({super.key});

  @override
  State<HostNotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<HostNotificationScreen> {
  final ApproveUserController controller = Get.put(ApproveUserController());
  // final RequestedUsersController _requestedUsersController = Get.put(
  //   RequestedUsersController(),
  // );

  @override
  void initState() {
    super.initState();
    controller.requestingUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Pending Approvals",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2E8B7F), Color(0xFF1F5F5B), Color(0xFF0D4F47)],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            return ListView.builder(
              itemCount: controller.employee.length,
              itemBuilder: (context, index) {
                final user = controller.employee[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Username
                        Text(
                          user.username,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Role dropdown
                        DropdownButtonFormField<String>(
                          value: user.selectedRole,
                          hint: const Text("Select Role"),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: ["lead", "employee"]
                              .map(
                                (role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              controller.employee[index].selectedRole = value;
                              controller.employee.refresh();
                            });
                          },
                        ),

                        const SizedBox(height: 12),

                        // Approve / Reject buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  if (controller.employee[index].selectedRole !=
                                      null) {
                                    controller.approveUser(
                                      user.id,
                                      controller.employee[index].selectedRole
                                          .toString(),
                                      // index,
                                    );
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.green,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                ),
                                child: const Text(
                                  "Approve",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () async {
                                  await controller.rejectUser(user.id);
                                  // controller.employee.removeAt(index);
                                  // controller.usernames.removeAt(index);

                                  Get.snackbar(
                                    "Rejected",
                                    "User rejected successfully",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: const Color.fromARGB(
                                      200,
                                      224,
                                      78,
                                      68,
                                    ),
                                    colorText: Colors.white,
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.redAccent,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                ),
                                child: const Text(
                                  "Reject",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
