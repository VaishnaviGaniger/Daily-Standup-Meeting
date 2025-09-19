class UpdateProfileModel {
  int id;
  String username;
  String email;
  String phone;
  String address;
  String? profile;
  String dob;
  String designation;

  UpdateProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.address,
    this.profile,
    required this.dob,
    required this.designation,
  });

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) =>
      UpdateProfileModel(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
        profile: json["profile"],
        dob: json["dob"],
        designation: json["designation"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "phone": phone,
    "address": address,
    "profile": profile,
    "dob": dob,
    "designation": designation,
  };
}
