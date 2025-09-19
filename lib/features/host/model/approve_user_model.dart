class ApproveUserModel {
  final int id;
  final String username;
  String? selectedRole;

  ApproveUserModel({
    required this.id,
    required this.username,
    this.selectedRole,
  });

  factory ApproveUserModel.fromJson(Map<String, dynamic> json) {
    return ApproveUserModel(id: json['id'], username: json['username']);
  }
}
