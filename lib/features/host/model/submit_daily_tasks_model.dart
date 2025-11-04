class SubmitDailyUpdatesModel {
  final List<YesterdayTask> yesterday;
  final List<TodayTask> today;
  final Blocker? blockers;

  SubmitDailyUpdatesModel({
    required this.yesterday,
    required this.today,
    this.blockers,
  });

  Map<String, dynamic> toJson() {
    return {
      "yesterday": yesterday.map((e) => e.toJson()).toList(),
      "today": today.map((e) => e.toJson()).toList(),
      "blockers": blockers?.toJson() ?? {"project_id": "", "description": ""},
    };
  }
}

class YesterdayTask {
  final int projectId;
  final List<Task> tasks;

  YesterdayTask({required this.projectId, required this.tasks});

  Map<String, dynamic> toJson() {
    return {
      "project_id": projectId,
      "tasks": tasks.map((e) => e.toJson()).toList(),
    };
  }
}

class TodayTask {
  final int projectId;
  final List<Task> tasks;

  TodayTask({required this.projectId, required this.tasks});

  Map<String, dynamic> toJson() {
    return {
      "project_id": projectId,
      "tasks": tasks.map((e) => e.toJson()).toList(),
    };
  }
}

class Task {
  final String description;
  final String time;
  final String status;

  Task({required this.description, required this.time, required this.status});

  Map<String, dynamic> toJson() {
    return {"description": description, "time": time, "status": status};
  }
}

class Blocker {
  final String projectId;
  final String description;

  Blocker({required this.projectId, required this.description});

  Map<String, dynamic> toJson() {
    return {"project_id": projectId, "description": description};
  }
}

class SubmitDailyUpdateResponseModel {
  final String message;

  SubmitDailyUpdateResponseModel({required this.message});

  factory SubmitDailyUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return SubmitDailyUpdateResponseModel(message: json['message'] ?? '');
  }
}

// class SubmitDailyUpdatesModel {
//   final List<YesterdayTask> yesterdayTasks;
//   final List<TodayTask> todayTasks;
//   final Blocker? blockers;

//   SubmitDailyUpdatesModel({
//     required this.yesterdayTasks,
//     required this.todayTasks,
//     this.blockers,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       "yesterday_tasks": yesterdayTasks.map((e) => e.toJson()).toList(),
//       "today_tasks": todayTasks.map((e) => e.toJson()).toList(),
//       if (blockers != null) "blockers": blockers!.toJson(),
//     };
//   }
// }

// class YesterdayTask {
//   final int project;
//   final List<String> taskDescription;
//   final List<String> timeTaken;
//   final List<String> status;

//   YesterdayTask({
//     required this.project,
//     required this.taskDescription,
//     required this.timeTaken,
//     required this.status,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       "project": project,
//       "task_description": taskDescription,
//       "time_taken": timeTaken,
//       "status": status,
//     };
//   }
// }

// class TodayTask {
//   final int project;
//   final List<String> taskDescription;
//   final List<String> timeTaken;
//   final List<String> status;

//   TodayTask({
//     required this.project,
//     required this.taskDescription,
//     required this.timeTaken,
//     required this.status,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       "project": project,
//       "task_description": taskDescription,
//       "time_taken": timeTaken,
//       "status": status,
//     };
//   }
// }

// class Blocker {
//   final int? project;
//   final String description;

//   Blocker({required this.project, required this.description});

//   Map<String, dynamic> toJson() {
//     return {"project": project, "description": description};
//   }
// }

// class SubmitDailyUpdateResponseModel {
//   final String detail;

//   SubmitDailyUpdateResponseModel({required this.detail});

//   factory SubmitDailyUpdateResponseModel.fromJson(Map<String, dynamic> json) {
//     return SubmitDailyUpdateResponseModel(detail: json['detail'] ?? '');
//   }
// }
