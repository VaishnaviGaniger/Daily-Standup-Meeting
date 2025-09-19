class RegisterRequestModel {
  // final String role;
  final String username;
  final String email;
  final String password;
  //final String confirmpassword;
  final String phone;
  final String address;
  final String dob;
  final String designation;

  RegisterRequestModel({
    // required this.role,
    required this.username,
    required this.email,
    required this.password,
    // required this.confirmpassword,
    required this.phone,
    required this.address,
    required this.dob,
    required this.designation,
  });

  Map<String, String> toJson() {
    return {
      // 'role': role,
      'username': username,
      'email': email,
      'password': password,
      //'confirmpassword':confirmpassword
      'phone': phone,
      "address": address,
      "dob": dob,
      "designation": designation,
    };
  }
}
