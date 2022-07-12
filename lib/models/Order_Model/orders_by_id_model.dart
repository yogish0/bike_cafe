import 'dart:convert';

GetUserOrdersByIdModel getUserOrdersByIdModelFromMap(String str) => GetUserOrdersByIdModel.fromMap(json.decode(str));

class GetUserOrdersByIdModel {
  GetUserOrdersByIdModel({
    required this.order,
    required this.message,
    required this.success,
  });

  List<Order> order;
  String? message;
  String? success;

  factory GetUserOrdersByIdModel.fromMap(Map<String, dynamic> json) => GetUserOrdersByIdModel(
    order: List<Order>.from(json["order"].map((x) => Order.fromMap(x))),
    message: json["message"],
    success: json["success"],
  );
}

class Order {
  Order({
    required this.orderid,
    required this.id,
    required this.ordRefid,
    required this.ordUserId,
    required this.ordStatusId,
    required this.ordPaymentStatusId,
    required this.ordTax,
    required this.ordDeliveryFee,
    required this.ordHint,
    required this.ordActive,
    required this.ordDeliveryAddressId,
    required this.ordPaymethodId,
    required this.ordTotalPrice,
    required this.ordEstDelivery,
    required this.paystaStatusName,
    required this.paymetName,
    required this.ordstaStatus,
    required this.productid,
    required this.proName,
    required this.proDescription,
    required this.proCapacity,
    required this.proCode,
    required this.proSku,
    required this.packageItemsCount,
    required this.proImagePath,
    required this.proUnit,
    required this.proFeatured,
    required this.proItemGrade,
    required this.proIsoutofstock,
    required this.proStockCount,
    required this.proVendorId,
    required this.proCategoryId,
    required this.proSubCategoryId,
    required this.proManuId,
    required this.proTax,
    required this.proIsactive,
    required this.proIsdeleted,
    required this.deliveryDate,
  });

  int? orderid;
  int? id;
  String? ordRefid;
  int? ordUserId;
  int? ordStatusId;
  int? ordPaymentStatusId;
  dynamic ordTax;
  dynamic ordDeliveryFee;
  dynamic ordHint;
  int? ordActive;
  int? ordDeliveryAddressId;
  int? ordPaymethodId;
  dynamic ordTotalPrice;
  dynamic ordEstDelivery;
  String? paystaStatusName;
  String? paymetName;
  String? ordstaStatus;
  int? productid;
  String? proName;
  String? proDescription;
  int? proCapacity;
  String? proCode;
  String? proSku;
  int? packageItemsCount;
  String? proImagePath;
  String? proUnit;
  int? proFeatured;
  dynamic proItemGrade;
  int? proIsoutofstock;
  dynamic proStockCount;
  int? proVendorId;
  int? proCategoryId;
  int? proSubCategoryId;
  dynamic proManuId;
  dynamic proTax;
  int? proIsactive;
  dynamic proIsdeleted;
  dynamic deliveryDate;

  factory Order.fromMap(Map<String, dynamic> json) => Order(
    orderid: json["orderid"],
    id: json["id"],
    ordRefid: json["ord_refid"],
    ordUserId: json["ord_user_id"],
    ordStatusId: json["ord_status_id"],
    ordPaymentStatusId: json["ord_payment_status_id"],
    ordTax: json["ord_tax"],
    ordDeliveryFee: json["ord_delivery_fee"],
    ordHint: json["ord_hint"],
    ordActive: json["ord_active"],
    ordDeliveryAddressId: json["ord_delivery_address_id"],
    ordPaymethodId: json["ord_paymethod_id"],
    ordTotalPrice: json["ord_total_price"],
    ordEstDelivery: json["ord_est_delivery"],
    paystaStatusName: json["paysta_status_name"],
    paymetName: json["paymet_name"],
    ordstaStatus: json["ordsta_status"],
    productid: json["productid"],
    proName: json["pro_name"],
    proDescription: json["pro_description"],
    proCapacity: json["pro_capacity"],
    proCode: json["pro_code"],
    proSku: json["pro_sku"],
    packageItemsCount: json["package_items_count"],
    proImagePath: json["pro_image_path"],
    proUnit: json["pro_unit"],
    proFeatured: json["pro_featured"],
    proItemGrade: json["pro_item_grade"],
    proIsoutofstock: json["pro_isoutofstock"],
    proStockCount: json["pro_stock_count"],
    proVendorId: json["pro_vendor_id"],
    proCategoryId: json["pro_category_id"],
    proSubCategoryId: json["pro_sub_category_id"],
    proManuId: json["pro_manu_id"],
    proTax: json["pro_tax"],
    proIsactive: json["pro_isactive"],
    proIsdeleted: json["pro_isdeleted"],
    deliveryDate: json["delivery date"],
  );
}
