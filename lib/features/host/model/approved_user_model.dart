class ApprovedUserModel {
  final String role;
  // final bool is_approved;

  ApprovedUserModel({
    required this.role,
    // required this.is_approved
  });

  Map<String, dynamic> toJson() {
    return {
      "role": role,
      //"is_approved": is_approved
    };
  }
}
