// To parse this JSON data, do
//
//     final vechileModelByBrandId = vechileModelByBrandIdFromJson(jsonString);

import 'dart:convert';

VechileModelByBrandId vechileModelByBrandIdFromJson(String str) =>
    VechileModelByBrandId.fromJson(json.decode(str));

String vechileModelByBrandIdToJson(VechileModelByBrandId data) =>
    json.encode(data.toJson());

class VechileModelByBrandId {
  VechileModelByBrandId({
    required this.body,
    this.success,
    this.message,
  });

  List<Body2> body;
  String? success;
  String? message;

  factory VechileModelByBrandId.fromJson(Map<String, dynamic> json) =>
      VechileModelByBrandId(
        body: List<Body2>.from(json["body"].map((x) => Body2.fromJson(x))),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "body": List<dynamic>.from(body.map((x) => x.toJson())),
        "success": success,
        "message": message,
      };
}

class Body2 {
  Body2({
    this.id,
    this.vehmodName,
    this.vehmodCode,
    this.vehmodCatId,
    this.vehmodBrandId,
    this.vehmodIsactive,
    this.vehmodIsdelete,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? vehmodName;
  dynamic? vehmodCode;
  int? vehmodCatId;
  int? vehmodBrandId;
  int? vehmodIsactive;
  int? vehmodIsdelete;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Body2.fromJson(Map<String, dynamic> json) => Body2(
        id: json["id"],
        vehmodName: json["vehmod_name"],
        vehmodCode: json["vehmod_code"],
        vehmodCatId: json["vehmod_cat_id"],
        vehmodBrandId: json["vehmod_brand_id"],
        vehmodIsactive: json["vehmod_isactive"],
        vehmodIsdelete: json["vehmod_isdelete"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehmod_name": vehmodName,
        "vehmod_code": vehmodCode,
        "vehmod_cat_id": vehmodCatId,
        "vehmod_brand_id": vehmodBrandId,
        "vehmod_isactive": vehmodIsactive,
        "vehmod_isdelete": vehmodIsdelete,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
