import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/features/employees/controller/meeting_update_controller.dart';
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

  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2E8B7F), Color(0xFF1F5F5B), Color(0xFF0D4F47)],
    stops: [0.0, 0.6, 1.0],
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _meetingUpdateController.fetchMeetingupdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meeting Updates',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2E8B7F),
        elevation: 0,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.notifications, color: Colors.white),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            await _meetingUpdateController.fetchMeetingupdates(),
        child: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "📌 Daily Standup Meeting Updates",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _meetingUpdateController.meetings.length,
                  itemBuilder: (context, index) {
                    final sortedMeetings =
                        List.from(_meetingUpdateController.meetings)..sort((
                          a,
                          b,
                        ) {
                          final aDateTime = DateTime.parse(
                            "${a.meeting_date} ${a.meeting_time}",
                          );
                          final bDateTime = DateTime.parse(
                            "${b.meeting_date} ${b.meeting_time}",
                          );
                          return bDateTime.compareTo(aDateTime); // recent first
                        });
                    final meeting = sortedMeetings[index];
                    String formattedTime = "";
                    try {
                      final parsedTime = DateFormat(
                        "HH:mm:ss",
                      ).parse(meeting.meeting_time);
                      formattedTime = DateFormat(
                        "hh:mm a",
                      ).format(parsedTime); // → 02:30 PM
                    } catch (e) {
                      formattedTime =
                          meeting.meeting_time; // fallback if format mismatch
                    }
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        gradient: mainGradient,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                        title: Text(
                          meeting.about,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  formattedTime,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  meeting.meeting_date,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                const Icon(
                                  Icons.group,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${meeting.participants.length} participants",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  onPressed: () async {
                                    if (meeting.link != null &&
                                        meeting.link!.isNotEmpty) {
                                      final Uri url = Uri.parse(meeting.link);
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(
                                          url,
                                          mode: LaunchMode.externalApplication,
                                        );
                                      } else {
                                        debugPrint("Could not launch $url");
                                      }
                                    } else {
                                      debugPrint("Meeting link is empty");
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.link,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            meeting.host,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Text(
                  "📌 Other Meeting Updates",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
