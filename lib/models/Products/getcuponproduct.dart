// To parse this JSON data, do
//
//     final getCuponProductModel = getCuponProductModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetCuponProductModel getCuponProductModelFromMap(String str) => GetCuponProductModel.fromMap(json.decode(str));

String getCuponProductModelToMap(GetCuponProductModel data) => json.encode(data.toMap());

class GetCuponProductModel {
    GetCuponProductModel({
        required this.products,
        required this.message,
        required this.success,
    });

    final List<Product>? products;
    final String message;
    final int success;

    factory GetCuponProductModel.fromMap(Map<String, dynamic> json) => GetCuponProductModel(
        products: json["Products"] == null ? null : List<Product>.from(json["Products"].map((x) => Product.fromMap(x))),
        message: json["message"] == null ? null : json["message"],
        success: json["success"] == null ? null : json["success"],
    );

    Map<String, dynamic> toMap() => {
        "Products": products == null ? null : List<dynamic>.from(products!.map((x) => x.toMap())),
        "message": message == null ? null : message,
        "success": success == null ? null : success,
    };
}

class Product {
    Product({
        required this.couponid,
        required this.couCode,
        required this.couDiscount,
        required this.couDiscountType,
        required this.couDescription,
        required this.couRedeemableCount,
        required this.couMaxDiscount,
        required this.couMinOrderValue,
        required this.couValidFrom,
        required this.couExpiresAt,
        required this.productid,
        required this.proName,
        required this.proDescription,
        required this.proCode,
        required this.proSku,
        required this.proImagePath,
        required this.proCategoryId,
        required this.proTax,
        required this.proVendorId,
        required this.proIsoutofstock,
        required this.procosProductId,
        required this.procosMrp,
        required this.procosSellingPrice,
    });

    final int couponid;
    final String couCode;
    final int couDiscount;
    final String couDiscountType;
    final String couDescription;
    final int couRedeemableCount;
    final int couMaxDiscount;
    final int couMinOrderValue;
    final DateTime? couValidFrom;
    final DateTime? couExpiresAt;
    final int productid;
    final String proName;
    final String proDescription;
    final String proCode;
    final String proSku;
    final String proImagePath;
    final int proCategoryId;
    final int proTax;
    final int proVendorId;
    final int proIsoutofstock;
    final int procosProductId;
    final int procosMrp;
    final int procosSellingPrice;

    factory Product.fromMap(Map<String, dynamic> json) => Product(
        couponid: json["couponid"] == null ? null : json["couponid"],
        couCode: json["cou_code"] == null ? null : json["cou_code"],
        couDiscount: json["cou_discount"] == null ? null : json["cou_discount"],
        couDiscountType: json["cou_discount_type"] == null ? null : json["cou_discount_type"],
        couDescription: json["cou_description"] == null ? null : json["cou_description"],
        couRedeemableCount: json["cou_redeemable_count"] == null ? null : json["cou_redeemable_count"],
        couMaxDiscount: json["cou_max_discount"] == null ? null : json["cou_max_discount"],
        couMinOrderValue: json["cou_min_order_value"] == null ? null : json["cou_min_order_value"],
        couValidFrom: json["cou_valid_from"] == null ? null : DateTime.parse(json["cou_valid_from"]),
        couExpiresAt: json["cou_expires_at"] == null ? null : DateTime.parse(json["cou_expires_at"]),
        productid: json["Productid"] == null ? null : json["Productid"],
        proName: json["pro_name"] == null ? null : json["pro_name"],
        proDescription: json["pro_description"] == null ? null : json["pro_description"],
        proCode: json["pro_code"] == null ? null : json["pro_code"],
        proSku: json["pro_sku"] == null ? null : json["pro_sku"],
        proImagePath: json["pro_image_path"] == null ? null : json["pro_image_path"],
        proCategoryId: json["pro_category_id"] == null ? null : json["pro_category_id"],
        proTax: json["pro_tax"] == null ? null : json["pro_tax"],
        proVendorId: json["pro_vendor_id"] == null ? null : json["pro_vendor_id"],
        proIsoutofstock: json["pro_isoutofstock"] == null ? null : json["pro_isoutofstock"],
        procosProductId: json["procos_product_id"] == null ? null : json["procos_product_id"],
        procosMrp: json["procos_mrp"] == null ? null : json["procos_mrp"],
        procosSellingPrice: json["procos_selling_price"] == null ? null : json["procos_selling_price"],
    );

    Map<String, dynamic> toMap() => {
        "couponid": couponid == null ? null : couponid,
        "cou_code": couCode == null ? null : couCode,
        "cou_discount": couDiscount == null ? null : couDiscount,
        "cou_discount_type": couDiscountType == null ? null : couDiscountType,
        "cou_description": couDescription == null ? null : couDescription,
        "cou_redeemable_count": couRedeemableCount == null ? null : couRedeemableCount,
        "cou_max_discount": couMaxDiscount == null ? null : couMaxDiscount,
        "cou_min_order_value": couMinOrderValue == null ? null : couMinOrderValue,
        "cou_valid_from": couValidFrom == null ? null : couValidFrom!.toIso8601String(),
        "cou_expires_at": couExpiresAt == null ? null : couExpiresAt!.toIso8601String(),
        "Productid": productid == null ? null : productid,
        "pro_name": proName == null ? null : proName,
        "pro_description": proDescription == null ? null : proDescription,
        "pro_code": proCode == null ? null : proCode,
        "pro_sku": proSku == null ? null : proSku,
        "pro_image_path": proImagePath == null ? null : proImagePath,
        "pro_category_id": proCategoryId == null ? null : proCategoryId,
        "pro_tax": proTax == null ? null : proTax,
        "pro_vendor_id": proVendorId == null ? null : proVendorId,
        "pro_isoutofstock": proIsoutofstock == null ? null : proIsoutofstock,
        "procos_product_id": procosProductId == null ? null : procosProductId,
        "procos_mrp": procosMrp == null ? null : procosMrp,
        "procos_selling_price": procosSellingPrice == null ? null : procosSellingPrice,
    };
}
