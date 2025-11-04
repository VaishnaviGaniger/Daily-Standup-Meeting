class RegisterfcmtokenModel {
  final String token;

  RegisterfcmtokenModel({required this.token});

  Map<String,String> toJson(){
    return {
      "token":token
    };
  }

}