// To parse this JSON data, do
//
//     final vechilevariantType = vechilevariantTypeFromJson(jsonString);

import 'dart:convert';

VechilevariantType vechilevariantTypeFromJson(String str) =>
    VechilevariantType.fromJson(json.decode(str));

String vechilevariantTypeToJson(VechilevariantType data) =>
    json.encode(data.toJson());

class VechilevariantType {
  VechilevariantType({
    required this.body,
    this.success,
    this.message,
  });

  List<Body3> body;
  String? success;
  String? message;

  factory VechilevariantType.fromJson(Map<String, dynamic> json) =>
      VechilevariantType(
        body: List<Body3>.from(json["body"].map((x) => Body3.fromJson(x))),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "body": List<dynamic>.from(body.map((x) => x.toJson())),
        "success": success,
        "message": message,
      };
}

class Body3 {
  Body3({
    this.id,
    this.vehvarName,
    this.vehvarCode,
    this.vehvarCc,
    this.vehvarModelId,
    this.vehvarLaunchYear,
    this.vehvarEndYear,
    this.vehmodIsactive,
    this.vehmodIsdelete,
    this.createdAt,
    this.updatedAt,
    this.vehmodName,
    this.vehmodCode,
    this.vehmodCatId,
    this.vehmodBrandId,
  });

  int? id;
  String? vehvarName;
  dynamic? vehvarCode;
  String? vehvarCc;
  int? vehvarModelId;
  int? vehvarLaunchYear;
  dynamic vehvarEndYear;
  int? vehmodIsactive;
  int? vehmodIsdelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? vehmodName;
  dynamic? vehmodCode;
  int? vehmodCatId;
  int? vehmodBrandId;

  factory Body3.fromJson(Map<String, dynamic> json) => Body3(
        id: json["id"],
        vehvarName: json["vehvar_name"],
        vehvarCode: json["vehvar_code"],
        vehvarCc: json["vehvar_cc"],
        vehvarModelId: json["vehvar_model_id"],
        vehvarLaunchYear: json["vehvar_launch_year"],
        vehvarEndYear: json["vehvar_end_year"],
        vehmodIsactive: json["vehmod_isactive"],
        vehmodIsdelete: json["vehmod_isdelete"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        vehmodName: json["vehmod_name"],
        vehmodCode: json["vehmod_code"],
        vehmodCatId: json["vehmod_cat_id"],
        vehmodBrandId: json["vehmod_brand_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehvar_name": vehvarName,
        "vehvar_code": vehvarCode,
        "vehvar_cc": vehvarCc,
        "vehvar_model_id": vehvarModelId,
        "vehvar_launch_year": vehvarLaunchYear,
        "vehvar_end_year": vehvarEndYear,
        "vehmod_isactive": vehmodIsactive,
        "vehmod_isdelete": vehmodIsdelete,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "vehmod_name": vehmodName,
        "vehmod_code": vehmodCode,
        "vehmod_cat_id": vehmodCatId,
        "vehmod_brand_id": vehmodBrandId,
      };
}
