import 'dart:convert';

OtpRequestToMobileModel otpRequestToMobileModelFromMap(String str) => OtpRequestToMobileModel.fromMap(json.decode(str));

String otpRequestToMobileModelToMap(OtpRequestToMobileModel data) => json.encode(data.toMap());

class OtpRequestToMobileModel {
  OtpRequestToMobileModel({
    required this.smsid,
    required this.message,
    required this.success,
  });

  int? smsid;
  String? message;
  int? success;

  factory OtpRequestToMobileModel.fromMap(Map<String, dynamic> json) => OtpRequestToMobileModel(
    smsid: json["smsid"],
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "smsid": smsid,
    "message": message,
    "success": success,
  };
}

// verifying oto model

OtpVerifyByMobileModel otpVerifyByMobileModelFromMap(String str) => OtpVerifyByMobileModel.fromMap(json.decode(str));

String otpVerifyByMobileModelToMap(OtpVerifyByMobileModel data) => json.encode(data.toMap());

class OtpVerifyByMobileModel {
  OtpVerifyByMobileModel({
    required this.message,
    required this.success,
  });

  String? message;
  int? success;

  factory OtpVerifyByMobileModel.fromMap(Map<String, dynamic> json) => OtpVerifyByMobileModel(
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "message": message,
    "success": success,
  };
}