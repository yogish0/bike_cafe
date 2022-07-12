import 'dart:convert';

LogoutModel logoutModelFromJson(String str) =>
    LogoutModel.fromJson(json.decode(str));

String logoutModelToJson(LogoutModel data) => json.encode(data.toJson());

class LogoutModel {
  LogoutModel({
    this.apiToken,
  });

  String? apiToken;

  factory LogoutModel.fromJson(Map<String, dynamic> json) => LogoutModel(
        apiToken: json["api_token"],
      );

  Map<String, dynamic> toJson() => {
        "api_token": apiToken,
      };
}
