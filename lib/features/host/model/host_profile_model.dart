class HostProfileModel {
  final int id;
  final String username;
  final String email;
  final String phone;
  final String address;
  final String? profile;
  final String dob;
  final String designation;

  HostProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.address,
    required this.profile,
    required this.dob,
    required this.designation,
  });

  factory HostProfileModel.fromJson(Map<String, dynamic> json) {
    return HostProfileModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      profile: json['profile'],
      dob: json['dob'],
      designation: json['designation'],
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
