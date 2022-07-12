import 'dart:convert';

VerifyOnlinePaymentModel verifyOnlinePaymentModelFromMap(String str) => VerifyOnlinePaymentModel.fromMap(json.decode(str));

String verifyOnlinePaymentModelToMap(VerifyOnlinePaymentModel data) => json.encode(data.toMap());

class VerifyOnlinePaymentModel {
  VerifyOnlinePaymentModel({
    required this.orders,
    required this.success,
  });

  Orders orders;
  String? success;

  factory VerifyOnlinePaymentModel.fromMap(Map<String, dynamic> json) => VerifyOnlinePaymentModel(
    orders: Orders.fromMap(json["orders"]),
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "orders": orders.toMap(),
    "success": success,
  };
}

class Orders {
  Orders({
    required this.orderrefid,
    required this.orderid,
    required this.message,
    required this.estimatedDeliveryData,
    required this.success,
  });

  String? orderrefid;
  int? orderid;
  String? message;
  String? estimatedDeliveryData;
  String? success;

  factory Orders.fromMap(Map<String, dynamic> json) => Orders(
    orderrefid: json["orderrefid"],
    orderid: json["orderid"],
    message: json["message"],
    estimatedDeliveryData: json["estimated delivery data"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "orderrefid": orderrefid,
    "orderid": orderid,
    "message": message,
    "estimated delivery data": estimatedDeliveryData,
    "success": success,
  };
}
