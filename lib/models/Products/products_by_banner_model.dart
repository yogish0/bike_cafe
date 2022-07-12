
import 'dart:convert';

GetProductsByBannerModel getProductsByBannerModelFromMap(String str) => GetProductsByBannerModel.fromMap(json.decode(str));

String getProductsByBannerModelToMap(GetProductsByBannerModel data) => json.encode(data.toMap());

class GetProductsByBannerModel {
  GetProductsByBannerModel({
    required this.body,
    required this.message,
    required this.success,
  });

  List<Body> body;
  String? message;
  int? success;

  factory GetProductsByBannerModel.fromMap(Map<String, dynamic> json) => GetProductsByBannerModel(
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
    required this.cpProductId,
  });

  int cpProductId;

  factory Body.fromMap(Map<String, dynamic> json) => Body(
    cpProductId: json["cp_product_id"],
  );

  Map<String, dynamic> toMap() => {
    "cp_product_id": cpProductId,
  };
}
