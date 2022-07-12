
import 'dart:convert';

GetVechiclebyuserid getVechiclebyuseridFromMap(String str) => GetVechiclebyuserid.fromMap(json.decode(str));

String getVechiclebyuseridToMap(GetVechiclebyuserid data) => json.encode(data.toMap());

class GetVechiclebyuserid {
  GetVechiclebyuserid({
    required this.body,
    required this.message,
    required this.success,
  });

  List<Body> body;
  String? message;
  dynamic success;

  factory GetVechiclebyuserid.fromMap(Map<String, dynamic> json) => GetVechiclebyuserid(
    body: List<Body>.from(json["body"].map((x) => Body.fromMap(x))),
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "body": List<dynamic>.from(body.map((x) => x.toMap())),
    "message": message,
    "success": success,
  };
}

class Body {
  Body({
    required this.usevehRegId,
    required this.usevehVehicleNumber,
    required this.userId,
    required this.vehicleTypeId,
    required this.vehicleTypeName,
    required this.modelId,
    required this.modelName,
    required this.variantId,
    required this.variantName,
    required this.cc,
    required this.brandid,
    required this.brandname,
    required this.launchYear,
    required this.endYear,
    required this.vehicleImage,
  });

  int? usevehRegId;
  dynamic usevehVehicleNumber;
  int? userId;
  int? vehicleTypeId;
  String? vehicleTypeName;
  int? modelId;
  String? modelName;
  int? variantId;
  String? variantName;
  String? cc;
  int? brandid;
  String? brandname;
  dynamic vehicleImage;
  int? launchYear;
  dynamic endYear;

  factory Body.fromMap(Map<String, dynamic> json) => Body(
    usevehRegId: json["useveh_reg_id"],
    usevehVehicleNumber: json["useveh_vehicle_number"],
    userId: json["user_id"],
    vehicleTypeId: json["vehicle_type_id"],
    vehicleTypeName: json["vehicle_type_name"],
    modelId: json["model_id"],
    modelName: json["model_name"],
    variantId: json["variant_id"],
    variantName: json["variant_name"],
    cc: json["cc"],
    brandid: json["brandid"],
    brandname: json["brandname"],
    vehicleImage: json["Vehicle Image"],
    launchYear: json["Launch year"],
    endYear: json["End year"],
  );

  Map<String, dynamic> toMap() => {
    "useveh_reg_id": usevehRegId,
    "useveh_vehicle_number": usevehVehicleNumber,
    "user_id": userId,
    "vehicle_type_id": vehicleTypeId,
    "vehicle_type_name": vehicleTypeName,
    "model_id": modelId,
    "model_name": modelName,
    "variant_id": variantId,
    "variant_name": variantName,
    "cc": cc,
    "brandid": brandid,
    "brandname": brandname,
    "Vehicle Image": vehicleImage,
    "Launch year": launchYear,
    "End year": endYear,
  };
}
