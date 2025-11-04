import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/features/employees/controller/emp_profile_controller.dart';
import 'package:message_notifier/features/employees/controller/meeting_update_controller.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final MeetingUpdateController _meetingUpdateController = Get.put(
    MeetingUpdateController(),
  );
  final EmpProfileController _empProfileController = Get.put(
    EmpProfileController(),
  );

  @override
  void initState() {
    super.initState();
    _meetingUpdateController.fetchMeetingupdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.rich_teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _meetingUpdateController.fetchMeetingupdates(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Obx(
              () => _meetingUpdateController.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.rich_teal,
                      ),
                    )
                  : _meetingUpdateController.meetings.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      color: AppColors.rich_teal,
                      onRefresh: () async =>
                          await _meetingUpdateController.fetchMeetingupdates(),
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _meetingUpdateController.meetings.length,
                        itemBuilder: (context, index) {
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
                          return _buildMeetingCard(meeting);
                        },
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMeetingCard(dynamic meeting) {
    String formattedTime = _formatTime(meeting.meeting_time);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.rich_teal, AppColors.dark_teal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.rich_teal.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    meeting.about,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    meeting.host,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Meeting info section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildInfoRow(Icons.access_time_rounded, formattedTime),
                      const SizedBox(width: 60),
                      _buildInfoRow(
                        Icons.calendar_today_rounded,
                        meeting.meeting_date,
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),
                  _buildInfoRow(
                    Icons.group_outlined,
                    "${meeting.count} participants",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Join Button only
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async => await _launchMeetingLink(meeting.link),
                icon: const Icon(
                  Icons.link_rounded,
                  size: 18,
                  color: AppColors.rich_teal,
                ),
                label: const Text(
                  "Join Meeting",
                  style: TextStyle(
                    color: AppColors.rich_teal,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatTime(String time) {
    try {
      final parsedTime = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("hh:mm a").format(parsedTime);
    } catch (_) {
      return time;
    }
  }

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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          children: const [
            Icon(Icons.event_busy, size: 60, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              "No Meetings Scheduled Yet",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
