class LoginRequestModel {
  final String email;
  final String password;
  // final String role;

  LoginRequestModel({required this.email, required this.password});

  Map<String, String> toJson() {
    return {'email': email, 'password': password};
  }
}
