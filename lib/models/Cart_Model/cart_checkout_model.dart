import 'dart:convert';

CartCheckoutModel cartCheckoutModelFromMap(String str) => CartCheckoutModel.fromMap(json.decode(str));

String cartCheckoutModelToMap(CartCheckoutModel data) => json.encode(data.toMap());

class CartCheckoutModel {
  CartCheckoutModel({
    required this.coupons,
    required this.totalMrp,
    required this.total,
    required this.savings,
    required this.products,
    required this.cgst,
    required this.sgst,
    required this.totalTax,
    required this.deliverycharges,
    required this.couponapplied,
    required this.grandTotal,
    required this.message,
    required this.success,
  });

  final List<Product>? products;
  final List<Coupon>? coupons;
  final double total;
  final double totalMrp;
  final double savings;
  final double cgst;
  final double sgst;
  final double totalTax;
  final double deliverycharges;
  final dynamic couponapplied;
  final double grandTotal;
  final String message;
  final String success;

  factory CartCheckoutModel.fromMap(Map<String, dynamic> json) => CartCheckoutModel(
    products: json["Products"] == null ? [] : List<Product>.from(json["Products"].map((x) => Product.fromMap(x))),
    coupons: json["Coupons"] == null ? null : List<Coupon>.from(json["Coupons"].map((x) => Coupon.fromMap(x))),
    total: json["Total"] == null ? 0 : json["Total"].toDouble(),
    totalMrp: json["TotalMRP"] == null ? 0 : json["TotalMRP"].toDouble(),
    savings: json["Savings"] == null ? 0 : json["Savings"].toDouble(),
    cgst: json["CGST"] == null ? 0 : json["CGST"].toDouble(),
    sgst: json["SGST"] == null ? 0 : json["SGST"].toDouble(),
    totalTax: json["TotalTax"] == null ? 0 : json["TotalTax"].toDouble(),
    deliverycharges: json["deliverycharges"] == null ? 0 : json["deliverycharges"].toDouble(),
    couponapplied: json["Couponapplied"],
    grandTotal: json["GrandTotal"] == null ? 0 : json["GrandTotal"].toDouble(),
    message: json["message"] == null ? null : json["message"],
    success: json["success"] == null ? null : json["success"],
  );

  Map<String, dynamic> toMap() => {
    "Products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toMap())),
    "Coupons": coupons == null ? null : List<dynamic>.from(coupons!.map((x) => x.toMap())),
    "Total": total == null ? 0 : total,
    "TotalMRP": totalMrp == null ? 0 : totalMrp,
    "Savings": savings == null ? 0 : savings,
    "CGST": cgst == null ? 0 : cgst,
    "SGST": sgst == null ? 0 : sgst,
    "TotalTax": totalTax == null ? 0 : totalTax,
    "deliverycharges": deliverycharges == null ? 0 : deliverycharges,
    "Couponapplied": couponapplied,
    "GrandTotal": grandTotal == null ? 0 : grandTotal,
    "message": message == null ? null : message,
    "success": success == null ? null : success,
  };
}

class Coupon {
  Coupon({
    required this.couponid,
    required this.couCode,
    required this.couDescription,
    required this.couMaxDiscount,
    required this.couMinOrderValue,
    required this.couDiscount,
    required this.couDiscountType,
  });

  final int couponid;
  final String couCode;
  final String couDescription;
  final int couMaxDiscount;
  final int couMinOrderValue;
  final int couDiscount;
  final String couDiscountType;

  factory Coupon.fromMap(Map<String, dynamic> json) => Coupon(
    couponid: json["couponid"] == null ? null : json["couponid"],
    couCode: json["cou_code"] == null ? null : json["cou_code"],
    couDescription: json["cou_description"] == null ? null : json["cou_description"],
    couMaxDiscount: json["cou_max_discount"] == null ? null : json["cou_max_discount"],
    couMinOrderValue: json["cou_min_order_value"] == null ? null : json["cou_min_order_value"],
    couDiscount: json["cou_discount"] == null ? null : json["cou_discount"],
    couDiscountType: json["cou_discount_type"] == null ? null : json["cou_discount_type"],
  );

  Map<String, dynamic> toMap() => {
    "couponid": couponid == null ? null : couponid,
    "cou_code": couCode == null ? null : couCode,
    "cou_description": couDescription == null ? null : couDescription,
    "cou_max_discount": couMaxDiscount == null ? null : couMaxDiscount,
    "cou_min_order_value": couMinOrderValue == null ? null : couMinOrderValue,
    "cou_discount": couDiscount == null ? null : couDiscount,
    "cou_discount_type": couDiscountType == null ? null : couDiscountType,
  };
}

class Product {
  Product({
    required this.cartid,
    required this.productid,
    required this.productname,
    required this.proImagePath,
    required this.procosSellingPrice,
    required this.procosMrp,
    required this.applyCouponId,
    required this.catName,
    required this.opPrice,
    required this.proTax,
    required this.cartQuantity,
  });

  final int cartid;
  final int productid;
  final String productname;
  final String proImagePath;
  final int procosSellingPrice;
  final int procosMrp;
  final int applyCouponId;
  final String catName;
  final dynamic opPrice;
  final int proTax;
  final int cartQuantity;

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    cartid: json["cartid"] == null ? null : json["cartid"],
    productid: json["Productid"] == null ? null : json["Productid"],
    productname: json["Productname"] == null ? null : json["Productname"],
    proImagePath: json["pro_image_path"] == null ? null : json["pro_image_path"],
    procosSellingPrice: json["procos_selling_price"] == null ? null : json["procos_selling_price"],
    procosMrp: json["procos_mrp"] == null ? null : json["procos_mrp"],
    applyCouponId: json["apply_coupon_id"] == null ? null : json["apply_coupon_id"],
    catName: json["cat_name"] == null ? null : json["cat_name"],
    opPrice: json["op_price"],
    proTax: json["pro_tax"] == null ? null : json["pro_tax"],
    cartQuantity: json["cart_quantity"] == null ? null : json["cart_quantity"],
  );

  Map<String, dynamic> toMap() => {
    "cartid": cartid == null ? null : cartid,
    "Productid": productid == null ? null : productid,
    "Productname": productname == null ? null : productname,
    "pro_image_path": proImagePath == null ? null : proImagePath,
    "procos_selling_price": procosSellingPrice == null ? null : procosSellingPrice,
    "procos_mrp": procosMrp == null ? null : procosMrp,
    "apply_coupon_id": applyCouponId == null ? null : applyCouponId,
    "cat_name": catName == null ? null : catName,
    "op_price": opPrice,
    "pro_tax": proTax == null ? null : proTax,
    "cart_quantity": cartQuantity == null ? null : cartQuantity,
  };
}
