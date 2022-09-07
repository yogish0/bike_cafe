import 'dart:convert';

GetOrdersDetails getOrdersDetailsFromMap(String str) => GetOrdersDetails.fromMap(json.decode(str));

class GetOrdersDetails {
  GetOrdersDetails({
    required this.productorder,
    required this.message,
    required this.success,
  });

  List<Productorder> productorder;
  String? message;
  String? success;

  factory GetOrdersDetails.fromMap(Map<String, dynamic> json) => GetOrdersDetails(
    productorder: List<Productorder>.from(json["productorder"].map((x) => Productorder.fromMap(x))),
    message: json["message"],
    success: json["success"],
  );
}

class Productorder {
  Productorder({
    required this.productorderid,
    required this.id,
    required this.proordPrice,
    required this.proordQuantity,
    required this.proordProductId,
    required this.proordOrderId,
    required this.proordOrderStatusId,
    required this.proordPaymentMethodId,
    required this.proordPaymentStatusId,
    required this.proordPaymentRefid,
    required this.proordDeliveryRefid,
    required this.ordstaStatus,
    required this.paymetName,
    required this.paystaStatusName,
    required this.proName,
    required this.proDescription,
    required this.proCapacity,
    required this.proCode,
    required this.proSku,
    required this.packageItemsCount,
    required this.proImagePath,
    required this.proUnit,
    required this.proVendorId,
    required this.proCategoryId,
    required this.proSubCategoryId,
    required this.proTax,
    required this.deliveryaddressId,
    required this.name,
    required this.phonenumber,
    required this.altPhonenumber,
    required this.addDescription,
    required this.addAddress,
    required this.addCityId,
    required this.addPincode,
    required this.addLatitude,
    required this.addLongitude,
    required this.addIsDefault,
    required this.addUserId,
    required this.addIsactive,
    required this.addIsdeleted,
    required this.ordRefid,
    required this.deliveryDate,
  });

  int? productorderid;
  int? id;
  dynamic proordPrice;
  int? proordQuantity;
  int? proordProductId;
  int? proordOrderId;
  int? proordOrderStatusId;
  int? proordPaymentMethodId;
  int? proordPaymentStatusId;
  String? proordPaymentRefid;
  String? proordDeliveryRefid;
  String? ordstaStatus;
  String? paymetName;
  String? paystaStatusName;
  String? proName;
  String? proDescription;
  dynamic proCapacity;
  String? proCode;
  String? proSku;
  int? packageItemsCount;
  String? proImagePath;
  String? proUnit;
  int? proVendorId;
  int? proCategoryId;
  int? proSubCategoryId;
  dynamic proTax;
  int? deliveryaddressId;
  String? name;
  dynamic phonenumber;
  dynamic altPhonenumber;
  String? addDescription;
  String? addAddress;
  int? addCityId;
  int? addPincode;
  String? addLatitude;
  String? addLongitude;
  int? addIsDefault;
  int? addUserId;
  int? addIsactive;
  int? addIsdeleted;
  String? ordRefid;
  String? deliveryDate;

  factory Productorder.fromMap(Map<String, dynamic> json) => Productorder(
    productorderid: json["productorderid"],
    id: json["id"],
    proordPrice: json["proord_price"],
    proordQuantity: json["proord_quantity"],
    proordProductId: json["proord_product_id"],
    proordOrderId: json["proord_order_id"],
    proordOrderStatusId: json["proord_order_status_id"],
    proordPaymentMethodId: json["proord_payment_method_id"],
    proordPaymentStatusId: json["proord_payment_status_id"],
    proordPaymentRefid: json["proord_payment_refid"],
    proordDeliveryRefid: json["proord_delivery_refid"],
    ordstaStatus: json["ordsta_status"],
    paymetName: json["paymet_name"],
    paystaStatusName: json["paysta_status_name"],
    proName: json["pro_name"],
    proDescription: json["pro_description"],
    proCapacity: json["pro_capacity"],
    proCode: json["pro_code"],
    proSku: json["pro_sku"],
    packageItemsCount: json["package_items_count"],
    proImagePath: json["pro_image_path"],
    proUnit: json["pro_unit"],
    proVendorId: json["pro_vendor_id"],
    proCategoryId: json["pro_category_id"],
    proSubCategoryId: json["pro_sub_category_id"],
    proTax: json["pro_tax"],
    deliveryaddressId: json["Deliveryaddress id"],
    name: json["name"],
    phonenumber: json["phonenumber"],
    altPhonenumber: json["alt_phonenumber"],
    addDescription: json["add_description"],
    addAddress: json["add_address"],
    addCityId: json["add_city_id"],
    addPincode: json["add_pincode"],
    addLatitude: json["add_latitude"],
    addLongitude: json["add_longitude"],
    addIsDefault: json["add_is_default"],
    addUserId: json["add_user_id"],
    addIsactive: json["add_isactive"],
    addIsdeleted: json["add_isdeleted"],
    ordRefid: json["ord_refid"],
    deliveryDate: json["delivery date"],
  );
}
