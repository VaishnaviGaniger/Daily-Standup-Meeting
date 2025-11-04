class AllTasksUpdatesModel {
  final String date;
  final List<UserData> users;

  AllTasksUpdatesModel({required this.date, required this.users});

  factory AllTasksUpdatesModel.fromJson(Map<String, dynamic> json) {
    return AllTasksUpdatesModel(
      date: json['date'] ?? '',
      users:
          (json['users'] as List<dynamic>?)
              ?.map((e) => UserData.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'users': users.map((e) => e.toJson()).toList(),
  };
}

class UserData {
  final String username;
  final List<TaskData> whatYouDid;
  final List<TaskData> whatYouWillDo;
  final List<TaskData> blockers;

  UserData({
    required this.username,
    required this.whatYouDid,
    required this.whatYouWillDo,
    required this.blockers,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      username: json['username'] ?? '',
      whatYouDid:
          (json['what_you_did'] as List<dynamic>?)
              ?.map((e) => TaskData.fromJson(e))
              .toList() ??
          [],
      whatYouWillDo:
          (json['what_you_will_do'] as List<dynamic>?)
              ?.map((e) => TaskData.fromJson(e))
              .toList() ??
          [],
      blockers:
          (json['blockers'] as List<dynamic>?)
              ?.map((e) => TaskData.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'what_you_did': whatYouDid.map((e) => e.toJson()).toList(),
    'what_you_will_do': whatYouWillDo.map((e) => e.toJson()).toList(),
    'blockers': blockers.map((e) => e.toJson()).toList(),
  };
}

class TaskData {
  final String project;
  final String taskDescription;
  final String status;

  TaskData({
    required this.project,
    required this.taskDescription,
    required this.status,
  });

  factory TaskData.fromJson(Map<String, dynamic> json) {
    return TaskData(
      project: json['project'] ?? '',
      taskDescription: json['task_description'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'project': project,
    'task_description': taskDescription,
    'status': status,
  };
}

// class AllTasksUpdatesModel {
//   final String username;
//   final String projectname;
//   final String description;
//   final String? description1;
//   final String? description2;
//   final String taskdate;
//   final bool isPending;

//   AllTasksUpdatesModel({
//     required this.username,
//     required this.projectname,
//     required this.description,
//     required this.description1,
//     required this.description2,
//     required this.taskdate,
//     required this.isPending,
//   });

//   factory AllTasksUpdatesModel.fromJson(Map<String, dynamic> json) {
//     // Extract nested fields safely
//     final user = json["user"] ?? {};
//     final project = json["project"] ?? {};
//     final lead = json["project"]["lead"] ?? {};

//     return AllTasksUpdatesModel(
//       username: user["username"] ?? "",
//       projectname: project["name"] ?? "",
//       description: project["description"] ?? "",
//       description1: project["description2"] ?? "",
//       description2: project["description3"] ?? "",
//       taskdate: json["task_date"] ?? "",
//       isPending: lead["is_pending"] ?? false,
//     );
//   }
// }
