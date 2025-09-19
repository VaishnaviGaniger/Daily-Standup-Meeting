class StandupHistoryModel {
  final int id;
  final int user;
  final String projectname;
  final String discription;
  final String taskDate;

  StandupHistoryModel({
    required this.id,
    required this.user,
    required this.projectname,
    required this.discription,
    required this.taskDate,
  });

  factory StandupHistoryModel.fromJson(Map<String, dynamic> json) {
    return StandupHistoryModel(
      id: json["id"],
      user: json['user']['id'],
      discription: json['task_description'],
      projectname: json["project"]["name"],
      taskDate: json["task_date"],
    );
  }
}
