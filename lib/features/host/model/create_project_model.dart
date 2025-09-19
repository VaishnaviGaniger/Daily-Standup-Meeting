class CreateProjectModel {
  final String name;
  final String description;

  CreateProjectModel({required this.name, required this.description});

  Map<String, dynamic> toJson() {
    return {'name': name, "description": description};
  }
}

class createProjectResponse {
  final String message;

  createProjectResponse({required this.message});

  factory createProjectResponse.fromJson(Map<String, dynamic> json) {
    return createProjectResponse(message: json['message']);
  }
}
