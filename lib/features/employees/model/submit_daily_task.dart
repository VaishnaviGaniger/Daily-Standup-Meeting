class SubmitDailyTaskModel {
  final int project;
  final List<String> tasks_project;
  final List<String> time_taken;
  final List<String> status;

  SubmitDailyTaskModel({
    required this.project,
    required this.tasks_project,
    required this.time_taken,
    required this.status,
  });

  Map<String, dynamic> toJson(int index) {
    return {
      "project_$index": project,
      "tasks_project_$index": tasks_project,
      "time_taken_$index": time_taken,
      "status_$index": status,
    };
  }
}

class SubmitDailyTaskResponseModel {
  final String detail;

  SubmitDailyTaskResponseModel({required this.detail});

  factory SubmitDailyTaskResponseModel.fromJson(Map<String, dynamic> json) {
    return SubmitDailyTaskResponseModel(detail: json['detail'] ?? '');
  }
}
