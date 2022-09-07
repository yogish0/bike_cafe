// To parse this JSON data, do
//
//     final getPaymentOrder = getPaymentOrderFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetPaymentOrder getPaymentOrderFromMap(String str) => GetPaymentOrder.fromMap(json.decode(str));

String getPaymentOrderToMap(GetPaymentOrder data) => json.encode(data.toMap());

class GetPaymentOrder {
    GetPaymentOrder({
        required this.order,
        required this.message,
        required this.success,
    });

    final List<Order>? order;
    final String message;
    final String success;

    factory GetPaymentOrder.fromMap(Map<String, dynamic> json) => GetPaymentOrder(
        order: json["order"] == null ? null : List<Order>.from(json["order"].map((x) => Order.fromMap(x))),
        message: json["message"] == null ? null : json["message"],
        success: json["success"] == null ? null : json["success"],
    );

    Map<String, dynamic> toMap() => {
        "order": order == null ? null : List<dynamic>.from(order!.map((x) => x.toMap())),
        "message": message == null ? null : message,
        "success": success == null ? null : success,
    };
}

class Order {
    Order({
        required this.orderid,
        required this.orderRefId,
        required this.total,
        required this.tax,
        required this.deliveryfee,
        required this.paymentMethod,
        required this.couponCode,
    });

    final int orderid;
    final String orderRefId;
    final int total;
    final double tax;
    final int deliveryfee;
    final String paymentMethod;
    final dynamic couponCode;

    factory Order.fromMap(Map<String, dynamic> json) => Order(
        orderid: json["orderid"] == null ? null : json["orderid"],
        orderRefId: json["order ref id"] == null ? null : json["order ref id"],
        total: json["Total"] == null ? null : json["Total"],
        tax: json["Tax"] == null ? null : json["Tax"].toDouble(),
        deliveryfee: json["Deliveryfee"] == null ? null : json["Deliveryfee"],
        paymentMethod: json["payment method"] == null ? null : json["payment method"],
        couponCode: json["coupon code"],
    );

    Map<String, dynamic> toMap() => {
        "orderid": orderid == null ? null : orderid,
        "order ref id": orderRefId == null ? null : orderRefId,
        "Total": total == null ? null : total,
        "Tax": tax == null ? null : tax,
        "Deliveryfee": deliveryfee == null ? null : deliveryfee,
        "payment method": paymentMethod == null ? null : paymentMethod,
        "coupon code": couponCode,
    };
}
