import 'dart:convert';

OrderResponseModel orderResponseModelFromMap(String str) => OrderResponseModel.fromMap(json.decode(str));

String orderResponseModelToMap(OrderResponseModel data) => json.encode(data.toMap());

class OrderResponseModel {
  OrderResponseModel({
    required this.orders,
    required this.success,
  });

  Orders orders;
  String? success;

  factory OrderResponseModel.fromMap(Map<String, dynamic> json) => OrderResponseModel(
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
    required this.message,
    required this.estimatedDeliveryData,
    required this.success,
  });

  String? orderrefid;
  String? message;
  String? estimatedDeliveryData;
  int? success;

  factory Orders.fromMap(Map<String, dynamic> json) => Orders(
    orderrefid: json["orderrefid"],
    message: json["message"],
    estimatedDeliveryData: json["estimated delivery data"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "orderrefid": orderrefid,
    "message": message,
    "estimated delivery data": estimatedDeliveryData,
    "success": success,
  };
}
