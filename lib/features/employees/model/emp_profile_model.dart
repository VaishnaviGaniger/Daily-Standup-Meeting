class EmpProfileModel {
  final int id;
  final String username;
  final String email;
  final String phone;
  final String address;
  final String? dob;
  final String designation;
  final String? profile;

  EmpProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.address,
    required this.dob,
    required this.designation,
    this.profile,
  });

  factory EmpProfileModel.fromJson(Map<String, dynamic> json) {
    return EmpProfileModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      dob: json['dob'],
      designation: json['designation'],
      profile: json['profile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "phone": phone,
      "address": address,
      "dob": dob,
      "designation": designation,
      "profile": profile,
    };
  }
}
