class RejectUserModel {
  final bool is_approved;

  RejectUserModel({required this.is_approved});

  Map<String, dynamic> toJson() {
    return {"is_approved": is_approved};
  }
}
