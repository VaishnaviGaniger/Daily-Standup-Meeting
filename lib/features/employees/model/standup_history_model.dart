class StandupHistoryModel {
  final String date;
  final List<TaskData> yesterday;
  final List<TaskData> today;
  final List<TaskData> blockers;

  StandupHistoryModel({
    required this.date,
    required this.yesterday,
    required this.today,
    required this.blockers,
  });

  factory StandupHistoryModel.fromJson(Map<String, dynamic> json) {
    return StandupHistoryModel(
      date: json['date'] ?? '',
      yesterday:
          (json['yesterday'] as List<dynamic>?)
              ?.map((e) => TaskData.fromJson(e))
              .toList() ??
          [],
      today:
          (json['today'] as List<dynamic>?)
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
}

class TaskData {
  final int id;
  final int user;
  final String project_name;
  final String taskDescription;
  final String taskDate;
  final String status;
  final String? timeTaken;

  TaskData({
    required this.id,
    required this.user,
    required this.project_name,
    required this.taskDescription,
    required this.taskDate,
    required this.status,
    this.timeTaken,
  });

  factory TaskData.fromJson(Map<String, dynamic> json) {
    return TaskData(
      id: json['id'] ?? 0,
      user: json['user'] ?? 0,
      project_name: json['project_name'] ?? '',
      taskDescription: json['task_description'] ?? '',
      taskDate: json['task_date'] ?? '',
      status: json['status'] ?? '',
      timeTaken: json['time_taken'],
    );
  }
}

// class SubmitDailyUpdatesModel {
//   final List<ProjectTasks> yesterdayTasks;
//   final List<ProjectTasks> todayTasks;
//   final List<Blocker> blockers;

//   SubmitDailyUpdatesModel({
//     required this.yesterdayTasks,
//     required this.todayTasks,
//     required this.blockers,
//   });

//   factory SubmitDailyUpdatesModel.fromJson(Map<String, dynamic> json) {
//     return SubmitDailyUpdatesModel(
//       yesterdayTasks: (json['yesterday_tasks'] as List<dynamic>)
//           .map((e) => ProjectTasks.fromJson(e))
//           .toList(),
//       todayTasks: (json['today_tasks'] as List<dynamic>)
//           .map((e) => ProjectTasks.fromJson(e))
//           .toList(),
//       blockers: (json['blockers'] as List<dynamic>)
//           .map((e) => Blocker.fromJson(e))
//           .toList(),
//     );
//   }
// }

// class ProjectTasks {
//   final int projectId;
//   final String projectName;
//   final List<Task> tasks;

//   ProjectTasks({
//     required this.projectId,
//     required this.projectName,
//     required this.tasks,
//   });

//   factory ProjectTasks.fromJson(Map<String, dynamic> json) {
//     return ProjectTasks(
//       projectId: json['project_id'] ?? 0,
//       projectName: json['project_name'] ?? '',
//       tasks: (json['tasks'] as List<dynamic>)
//           .map((e) => Task.fromJson(e))
//           .toList(),
//     );
//   }
// }

// class Task {
//   final String taskDescription;
//   final String? timeTaken;
//   final String status;

//   Task({required this.taskDescription, this.timeTaken, required this.status});

//   factory Task.fromJson(Map<String, dynamic> json) {
//     return Task(
//       taskDescription: json['task_description'] ?? '',
//       timeTaken: json['time_taken'],
//       status: json['status'] ?? '',
//     );
//   }
// }

// class Blocker {
//   final int projectId;
//   final String projectName;
//   final String description;

//   Blocker({
//     required this.projectId,
//     required this.projectName,
//     required this.description,
//   });

//   factory Blocker.fromJson(Map<String, dynamic> json) {
//     return Blocker(
//       projectId: json['project_id'] ?? 0,
//       projectName: json['project_name'] ?? '',
//       description: json['description'] ?? '',
//     );
//   }
// }
