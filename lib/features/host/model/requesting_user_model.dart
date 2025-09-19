class RequestingUserModel {
  final String username;
  final int id;
  String? selectedRole;

  RequestingUserModel({
    required this.username,
    required this.id,
    this.selectedRole,
  });

  factory RequestingUserModel.fromJson(Map<String, dynamic> json) {
    return RequestingUserModel(username: json["username"], id: json['id']);
  }
}
