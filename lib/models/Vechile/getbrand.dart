// To parse this JSON data, do
//
//     final vechiletypeBrand = vechiletypeBrandFromJson(jsonString);

import 'dart:convert';

VechiletypeBrand vechiletypeBrandFromJson(String str) =>
    VechiletypeBrand.fromJson(json.decode(str));

String vechiletypeBrandToJson(VechiletypeBrand data) =>
    json.encode(data.toJson());

class VechiletypeBrand {
  VechiletypeBrand({
    required this.body,
    this.success,
    this.message,
  });

  List<Body> body;
  String? success;
  String? message;

  factory VechiletypeBrand.fromJson(Map<String, dynamic> json) =>
      VechiletypeBrand(
        body: List<Body>.from(json["body"].map((x) => Body.fromJson(x))),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "body": List<dynamic>.from(body.map((x) => x.toJson())),
        "success": success,
        "message": message,
      };
}

class Body {
  Body({
    this.brandid,
    this.brandName,
  });

  int? brandid;
  String? brandName;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        brandid: json["id"],
        brandName: json["brand_name"],
      );

  Map<String, dynamic> toJson() => {
        "brandid": brandid,
        "brand_name": brandName,
      };
}
