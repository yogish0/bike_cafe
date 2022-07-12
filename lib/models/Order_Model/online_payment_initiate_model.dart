import 'dart:convert';

OnlinePaymentInitiateModel onlinePaymentInitiateModelFromMap(String str) => OnlinePaymentInitiateModel.fromMap(json.decode(str));

String onlinePaymentInitiateModelToMap(OnlinePaymentInitiateModel data) => json.encode(data.toMap());

class OnlinePaymentInitiateModel {
  OnlinePaymentInitiateModel({
    required this.orders,
    required this.success,
  });

  Orders orders;
  String? success;

  factory OnlinePaymentInitiateModel.fromMap(Map<String, dynamic> json) => OnlinePaymentInitiateModel(
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
    required this.gologixTranctionid,
    required this.orderrefid,
    required this.paymentid,
    required this.orderid,
  });

  String? gologixTranctionid;
  String? orderrefid;
  int? paymentid;
  int? orderid;

  factory Orders.fromMap(Map<String, dynamic> json) => Orders(
    gologixTranctionid: json["GologixTranctionid"],
    orderrefid: json["Orderrefid"],
    paymentid: json["Paymentid"],
    orderid: json["orderid"],
  );

  Map<String, dynamic> toMap() => {
    "GologixTranctionid": gologixTranctionid,
    "Orderrefid": orderrefid,
    "Paymentid": paymentid,
    "orderid": orderid,
  };
}
