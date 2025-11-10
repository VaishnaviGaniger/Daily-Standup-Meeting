import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/features/host/controller/cancel_meeting_controller.dart';
import 'package:message_notifier/features/host/controller/host_profile_controller.dart';
import 'package:message_notifier/features/host/controller/meeting_update_host_controller.dart';
import 'package:message_notifier/features/host/view/create_project_screen.dart';
import 'package:message_notifier/features/host/view/host_profile_screen.dart';
import 'package:message_notifier/features/host/view/host_notification_screen.dart';
import 'package:message_notifier/features/host/view/schedule_meeting_screen.dart';
import 'package:message_notifier/features/host/view/updates_from_employee_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetingUpdateScreen extends StatefulWidget {
  const MeetingUpdateScreen({super.key});

  @override
  State<MeetingUpdateScreen> createState() => _MeetingUpdateScreenState();
}

class _MeetingUpdateScreenState extends State<MeetingUpdateScreen> {
  final MeetingUpdateHostController _meetingUpdateController = Get.put(
    MeetingUpdateHostController(),
  );
  final CancelMeetingController _cancelMeetingController = Get.put(
    CancelMeetingController(),
  );
  final MeetingUpdateHostController _meetingUpdateHostController = Get.put(
    MeetingUpdateHostController(),
  );
  final HostProfileController _hostProfileController = Get.put(
    HostProfileController(),
  );

  @override
  void initState() {
    super.initState();
    _meetingUpdateController.meetingupdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Meeting Updates",
          style: TextStyle(fontSize: 18, color: AppColors.white),
        ),
        backgroundColor: AppColors.rich_teal,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HostNotificationScreen(),
                ),
              );
            },
            icon: Icon(Icons.notifications, color: AppColors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HostProfileScreen()),
              );
            },
            icon: Icon(Icons.person, color: AppColors.white),
          ),
        ],
      ),

      drawer: Drawer(
        child: Obx(
          () => ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: AppColors.rich_teal),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white, size: 40),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _hostProfileController.hostProfile.value?.username ?? "",
                      style: const TextStyle(
                        color: Colors.white,

                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),

              ListTile(
                leading: const Icon(Icons.notes_rounded),
                title: const Text("Updates from Employees"),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdatesFromEmployeeScreen(),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text("Add New Project"),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateProjectScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: ElevatedButton.icon(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ScheduleMeetingScreen(),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.rich_teal,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Create Meeting",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Column(
        children: [
          // ✅ Create Meeting button (fixed)
          Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8)),

          // ✅ Scrollable list of meetings
          Expanded(
            child: Obx(
              () => RefreshIndicator(
                color: AppColors.dark_teal,
                backgroundColor: AppColors.whiteLogin,
                onRefresh: () async =>
                    await _meetingUpdateController.meetingupdates(),
                child: _meetingUpdateController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : _meetingUpdateController.meetings.isEmpty
                    ? const Center(
                        child: Text(
                          "No meetings scheduled yet.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _meetingUpdateController.meetings.length,
                        itemBuilder: (context, index) {
                          final meeting =
                              _meetingUpdateController.meetings[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.rich_teal,
                                  AppColors.dark_teal,
                                  AppColors.darkest_teal,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Row(
                                    children: [
                                      Text(
                                        meeting.about,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 60),

                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white24,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            meeting.host,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  // Date, time & participants
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        meeting.meeting_time,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Icon(
                                        Icons.calendar_today,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        meeting.meeting_date,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.group,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${meeting.count} participants",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          if (meeting.link.isNotEmpty) {
                                            final Uri url = Uri.parse(
                                              meeting.link,
                                            );
                                            if (await canLaunchUrl(url)) {
                                              await launchUrl(
                                                url,
                                                mode: LaunchMode
                                                    .externalApplication,
                                              );
                                            } else {
                                              Get.snackbar(
                                                "Error",
                                                "Could not launch meeting link",
                                              );
                                            }
                                          } else {
                                            Get.snackbar(
                                              "Notice",
                                              "Meeting link is empty",
                                            );
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.link,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          "Join Link",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white24,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final id = _meetingUpdateController
                                              .meetings[index]
                                              .id;

                                          final TextEditingController
                                          reasonController =
                                              TextEditingController();

                                          // Show input dialog
                                          final reason = await showDialog<String>(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                title: const Text(
                                                  "Cancel Meeting",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: TextField(
                                                  controller: reasonController,
                                                  decoration: const InputDecoration(
                                                    labelText:
                                                        "Enter cancellation reason",
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  maxLines: 2,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text(
                                                      "Dismiss",
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      final text =
                                                          reasonController.text
                                                              .trim();
                                                      if (text.isEmpty) {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              "Please enter a reason.",
                                                            ),
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent,
                                                          ),
                                                        );
                                                        return;
                                                      }
                                                      Navigator.pop(
                                                        context,
                                                        text,
                                                      );
                                                    },
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors
                                                                  .redAccent
                                                                  .shade400,
                                                        ),
                                                    child: const Text("Submit"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          // If reason entered, call API
                                          if (reason != null &&
                                              reason.isNotEmpty) {
                                            final id = _meetingUpdateController
                                                .meetings[index]
                                                .id;

                                            // ✅ Request body will be: {"reason": "<entered text>"}
                                            final Map<String, dynamic> body = {
                                              "reason": reason,
                                            };

                                            _cancelMeetingController
                                                .cancelMeeting(id, body);
                                            _meetingUpdateController.meetings
                                                .removeWhere(
                                                  (meeting) => meeting.id == id,
                                                );
                                            Get.snackbar(
                                              "Meeting Cancelled",
                                              "Meeting removed from the list successfully!",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor:
                                                  Colors.green.shade400,
                                              colorText: Colors.white,
                                              margin: EdgeInsets.all(12),
                                              borderRadius: 8,
                                              duration: Duration(seconds: 2),
                                            );
                                          }
                                        },

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.redAccent.shade400,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Cancel Meeting",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
