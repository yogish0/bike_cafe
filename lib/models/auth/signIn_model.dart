import 'dart:convert';
// ignore: file_names
// ignore: file_names
class SignInResponseModel {
  final String? token;
  final String? error;

  SignInResponseModel({this.token, this.error});

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) {
    return SignInResponseModel(
      token: json["api_token"] != null ? json["api_token"] : "",
      error: json["error"] != null ? json["error"] : "",
    );
  }
}

class SignInRequestModel {
  String? name;
  String? email;
  String? phoneNo;
  String? password;
  String? passwordConfirmation;

  SignInRequestModel(
      {this.name,
      this.email,
      this.phoneNo,
      this.password,
      this.passwordConfirmation});

  SignInRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneNo = json['phone_no'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_no'] = this.phoneNo;
    data['password'] = this.password;
    data['password_confirmation'] = this.passwordConfirmation;
    return data;
  }
}

SignUpResponseModel signUpResponseModelFromMap(String str) => SignUpResponseModel.fromMap(json.decode(str));

String signUpResponseModelToMap(SignUpResponseModel data) => json.encode(data.toMap());

class SignUpResponseModel {
  SignUpResponseModel({
    required this.userid,
    required this.message,
    required this.success,
  });

  int? userid;
  String? message;
  int? success;

  factory SignUpResponseModel.fromMap(Map<String, dynamic> json) => SignUpResponseModel(
    userid: json["userid"],
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "userid": userid,
    "message": message,
    "success": success,
  };
}
