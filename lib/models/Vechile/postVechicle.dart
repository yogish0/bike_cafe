import 'dart:convert';

PostVechileRequest postVechileRequestFromJson(String str) =>
    PostVechileRequest.fromJson(json.decode(str));

String postVechileRequestToJson(PostVechileRequest data) =>
    json.encode(data.toJson());

class PostVechileRequest {
  PostVechileRequest({
    this.categoryId,
    this.brandId,
    this.modelId,
    this.variantId,
    this.vehImageId,
    this.usevehVehicleNumber,
  });

  int? categoryId;
  int? brandId;
  int? modelId;
  int? variantId;
  String? vehImageId;
  String? usevehVehicleNumber;

  factory PostVechileRequest.fromJson(Map<String, dynamic> json) =>
      PostVechileRequest(
        categoryId: json["category_id"],
        brandId: json["brand_id"],
        modelId: json["model_id"],
        variantId: json["variant_id"],
        vehImageId: json["veh_image_id"],
        usevehVehicleNumber: json["useveh_vehicle_number"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "brand_id": brandId,
        "model_id": modelId,
        "variant_id": variantId,
        "veh_image_id": vehImageId,
        "useveh_vehicle_number": usevehVehicleNumber,
      };
}

//edit vehicle response model

EditVehicleResponseModel editVehicleResponseModelFromMap(String str) => EditVehicleResponseModel.fromMap(json.decode(str));

String editVehicleResponseModelToMap(EditVehicleResponseModel data) => json.encode(data.toMap());

class EditVehicleResponseModel {
  EditVehicleResponseModel({
    required this.body,
    required this.success,
    required this.message,
  });

  List<dynamic> body;
  String? success;
  String? message;

  factory EditVehicleResponseModel.fromMap(Map<String, dynamic> json) => EditVehicleResponseModel(
    body: List<dynamic>.from(json["body"].map((x) => x)),
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "body": List<dynamic>.from(body.map((x) => x)),
    "success": success,
    "message": message,
  };
}
