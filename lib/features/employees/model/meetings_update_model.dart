class MeetingsUpdateModel {
  final int id;
  final String host;
  final List<String> participants;
  final String about;
  final String meeting_time;
  final String meeting_date;
  final String link;

  MeetingsUpdateModel({
    required this.id,
    required this.host,
    required this.participants,
    required this.about,
    required this.meeting_time,
    required this.meeting_date,
    required this.link,
  });

  factory MeetingsUpdateModel.fromJson(Map<String, dynamic> json) {
    return MeetingsUpdateModel(
      id: json['id'],
      host: json['host'],
      participants:
          (json['participants'] as List<dynamic>?)
              ?.map((participant) => participant.toString())
              .toList() ??
          [],
      about: json['about'],
      meeting_time: json['meeting_time'],
      meeting_date: json['meeting_date'],
      link: json['link'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'host': host,
      'participants': participants,
      'about': about,
      'meeting_time': meeting_time,
      'meeting_date': meeting_date,
      'link': link,
    };
  }
}
