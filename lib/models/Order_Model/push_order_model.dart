import 'dart:convert';

PushOrderModel pushOrderModelFromJson(String str) => PushOrderModel.fromJson(json.decode(str));

class PushOrderModel {
  PushOrderModel({
    this.orderId,
    this.shipmentId,
    this.status,
    this.statusCode,
    this.onboardingCompletedNow,
    this.awbCode,
    this.courierCompanyId,
    this.courierName,
  });

  int? orderId;
  int? shipmentId;
  String? status;
  int? statusCode;
  int? onboardingCompletedNow;
  String? awbCode;
  String? courierCompanyId;
  String? courierName;

  factory PushOrderModel.fromJson(Map<String, dynamic> json) => PushOrderModel(
    orderId: json["order_id"],
    shipmentId: json["shipment_id"],
    status: json["status"],
    statusCode: json["status_code"],
    onboardingCompletedNow: json["onboarding_completed_now"],
    awbCode: json["awb_code"],
    courierCompanyId: json["courier_company_id"],
    courierName: json["courier_name"],
  );
}


ShipmentIdModel shipmentIdModelFromJson(String str) => ShipmentIdModel.fromJson(json.decode(str));

class ShipmentIdModel {
  ShipmentIdModel({
    this.message,
    this.success,
  });

  String? message;
  String? success;

  factory ShipmentIdModel.fromJson(Map<String, dynamic> json) => ShipmentIdModel(
    message: json["message"],
    success: json["success"],
  );
}