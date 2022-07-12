import 'dart:convert';

ForgotPasswordResponseModel forgotPasswordResponseModelFromMap(String str) => ForgotPasswordResponseModel.fromMap(json.decode(str));

String forgotPasswordResponseModelToMap(ForgotPasswordResponseModel data) => json.encode(data.toMap());

class ForgotPasswordResponseModel {
  ForgotPasswordResponseModel({
    required this.userid,
    required this.message,
    required this.success,
  });

  int? userid;
  String? message;
  int? success;

  factory ForgotPasswordResponseModel.fromMap(Map<String, dynamic> json) => ForgotPasswordResponseModel(
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
