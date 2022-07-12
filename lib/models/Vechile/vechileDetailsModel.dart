// To parse this JSON data, do
//
//     final vechicletypemodel = vechicletypemodelFromJson(jsonString);

import 'dart:convert';

Vechicletypemodel vechicletypemodelFromJson(String str) =>
    Vechicletypemodel.fromJson(json.decode(str));

String vechicletypemodelToJson(Vechicletypemodel data) =>
    json.encode(data.toJson());

class Vechicletypemodel {
  Vechicletypemodel({
    required this.body,
    this.success,
    this.message,
  });

  List<Body1> body;
  String? success;
  String? message;

  factory Vechicletypemodel.fromJson(Map<String, dynamic> json) =>
      Vechicletypemodel(
        body: List<Body1>.from(json["body"].map((x) => Body1.fromJson(x))),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "body": List<dynamic>.from(body.map((x) => x.toJson())),
        "success": success,
        "message": message,
      };
}

class Body1 {
  Body1({
    this.id,
    this.vehcatVehicleType,
    this.vehcatIsactive,
    this.vehcatIsdelete,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? vehcatVehicleType;
  int? vehcatIsactive;
  int? vehcatIsdelete;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Body1.fromJson(Map<String, dynamic> json) => Body1(
        id: json["id"],
        vehcatVehicleType: json["vehcat_vehicle_type"],
        vehcatIsactive: json["vehcat_isactive"],
        vehcatIsdelete: json["vehcat_isdelete"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehcat_vehicle_type": vehcatVehicleType,
        "vehcat_isactive": vehcatIsactive,
        "vehcat_isdelete": vehcatIsdelete,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
