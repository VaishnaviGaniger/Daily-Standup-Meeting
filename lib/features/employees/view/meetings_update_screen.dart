import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/features/employees/controller/emp_profile_controller.dart';
import 'package:message_notifier/features/employees/controller/meeting_update_controller.dart';
import 'package:message_notifier/features/employees/view/List_of_teammates_screen.dart';
import 'package:message_notifier/features/employees/view/assign_tasks_screen.dart';
import 'package:message_notifier/features/employees/view/emp_profile_screen.dart';
import 'package:message_notifier/features/employees/view/emp_notification_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class MeetingsUpdateScreen extends StatefulWidget {
  const MeetingsUpdateScreen({super.key});

  @override
  State<MeetingsUpdateScreen> createState() => _MeetingsUpdateScreenState();
}

class _MeetingsUpdateScreenState extends State<MeetingsUpdateScreen> {
  final MeetingUpdateController _meetingUpdateController = Get.put(
    MeetingUpdateController(),
  );
  final EmpProfileController _empProfileController = Get.put(
    EmpProfileController(),
  );

  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.rich_teal, AppColors.dark_teal, AppColors.darkest_teal],
    stops: [0.0, 0.6, 1.0],
  );

  @override
  void initState() {
    super.initState();
    _meetingUpdateController.fetchMeetingupdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meeting Updates',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.rich_teal,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
            icon: Icon(Icons.notifications, color: AppColors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeProfileScreen(),
                ),
              );
            },
            icon: Icon(Icons.person, color: AppColors.white),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
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
                    _empProfileController.profile.value?.username ?? '',
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
              leading: const Icon(Icons.list_alt),
              title: const Text("Assign Tasks"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AssignTasksScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.group_add),
              title: const Text("Add Teammates"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListOfTeammatesScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Obx(
        () => RefreshIndicator(
          color: AppColors.dark_teal,
          onRefresh: () async =>
              await _meetingUpdateController.fetchMeetingupdates(),
          child: _meetingUpdateController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : _meetingUpdateController.meetings.isEmpty
              ? const Center(
                  child: Text(
                    "No meetings scheduled yet.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: _meetingUpdateController.meetings.length,
                  itemBuilder: (context, index) {
                    // Sort meetings by most recent
                    final sortedMeetings =
                        List.from(_meetingUpdateController.meetings)
                          ..sort((a, b) {
                            final aDateTime = DateTime.parse(
                              "${a.meeting_date} ${a.meeting_time}",
                            );
                            final bDateTime = DateTime.parse(
                              "${b.meeting_date} ${b.meeting_time}",
                            );
                            return bDateTime.compareTo(aDateTime);
                          });

                    final meeting = sortedMeetings[index];
                    String formattedTime = _formatTime(meeting.meeting_time);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        gradient: mainGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.fromLTRB(
                          16,
                          10,
                          16,
                          10,
                        ),
                        title: Text(
                          meeting.about,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.access_time, formattedTime),
                            _buildInfoRow(
                              Icons.calendar_today,
                              meeting.meeting_date,
                            ),
                            _buildInfoRow(
                              Icons.group,
                              "${meeting.count} participants",
                            ),
                            Align(
                              // alignment: Alignment.topRight,
                              child: TextButton.icon(
                                onPressed: () async =>
                                    _launchMeetingLink(meeting.link),
                                icon: const Icon(
                                  Icons.link,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                label: const Text(
                                  "Join Meeting",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            meeting.host,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  /// Helper widget for small info rows
  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.white),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: AppColors.white),
          ),
        ],
      ),
    );
  }

  /// Format meeting time safely
  String _formatTime(String time) {
    try {
      final parsedTime = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("hh:mm a").format(parsedTime);
    } catch (_) {
      return time;
    }
  }

  /// Launch meeting link safely
  Future<void> _launchMeetingLink(String? link) async {
    if (link != null && link.isNotEmpty) {
      final Uri url = Uri.parse(link);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("Error", "Could not launch meeting link");
      }
    } else {
      Get.snackbar("Notice", "Meeting link is empty");
    }
  }
}
