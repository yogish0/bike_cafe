import 'dart:convert';

SendQueryModel sendQueryModelFromMap(String str) => SendQueryModel.fromMap(json.decode(str));

String sendQueryModelToMap(SendQueryModel data) => json.encode(data.toMap());

class SendQueryModel {
  SendQueryModel({
    required this.message,
    required this.success,
  });

  String? message;
  int? success;

  factory SendQueryModel.fromMap(Map<String, dynamic> json) => SendQueryModel(
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "message": message,
    "success": success,
  };
}