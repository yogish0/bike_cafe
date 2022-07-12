
import 'dart:convert';

VerifyOtpModel verifyOtpModelFromMap(String str) => VerifyOtpModel.fromMap(json.decode(str));

String verifyOtpModelToMap(VerifyOtpModel data) => json.encode(data.toMap());

class VerifyOtpModel {
  VerifyOtpModel({
    required this.message,
    required this.success,
  });

  String message;
  int success;

  factory VerifyOtpModel.fromMap(Map<String, dynamic> json) => VerifyOtpModel(
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "message": message,
    "success": success,
  };
}
