class ScheduleMeetingModel {
  final List<String> participants;
  final String about;
  final String meeting_time;
  final String meeting_date;
  final String link;

  ScheduleMeetingModel({
    required this.participants,
    required this.about,
    required this.meeting_time,
    required this.meeting_date,
    required this.link,
  });

  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'about': about,
      'meeting_time': meeting_time,
      'meeting_date': meeting_date,
      'link': link,
    };
  }
}
