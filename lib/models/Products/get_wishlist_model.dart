// To parse this JSON data, do
//
//     final getWishlistsProduct = getWishlistsProductFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetWishlistsProduct getWishlistsProductFromMap(String str) => GetWishlistsProduct.fromMap(json.decode(str));

String getWishlistsProductToMap(GetWishlistsProduct data) => json.encode(data.toMap());

class GetWishlistsProduct {
  GetWishlistsProduct({
    required this.wishlist,
    required this.message,
    required this.success,
  });

  List<Wishlist> wishlist;
  String message;
  int success;

  factory GetWishlistsProduct.fromMap(Map<String, dynamic> json) => GetWishlistsProduct(
    wishlist: List<Wishlist>.from(json["wishlist"].map((x) => Wishlist.fromMap(x))),
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "wishlist": List<dynamic>.from(wishlist.map((x) => x.toMap())),
    "message": message,
    "success": success,
  };
}

class Wishlist {
  Wishlist({
    required this.productid,
    required this.id,
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
    required this.proVendorId,
    required this.proCategoryId,
    required this.proSubCategoryId,
    required this.proManuId,
    required this.proTax,
    required this.proIsactive,
    required this.proIsdeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.procosProductId,
    required this.procosVendorId,
    required this.procosMrp,
    required this.procosSellingPrice,
    required this.procosVendorPrice,
    required this.procosAdminMargin,
    required this.procosIsflat,
  });

  int productid;
  int id;
  String proName;
  String proDescription;
  int proCapacity;
  String proCode;
  String proSku;
  int packageItemsCount;
  String proImagePath;
  String proUnit;
  int proFeatured;
  dynamic proItemGrade;
  int proIsoutofstock;
  int proVendorId;
  int proCategoryId;
  int proSubCategoryId;
  dynamic proManuId;
  int proTax;
  int proIsactive;
  dynamic proIsdeleted;
  DateTime createdAt;
  DateTime updatedAt;
  int procosProductId;
  int procosVendorId;
  int procosMrp;
  int procosSellingPrice;
  int procosVendorPrice;
  int procosAdminMargin;
  int procosIsflat;

  factory Wishlist.fromMap(Map<String, dynamic> json) => Wishlist(
    productid: json["Productid"],
    id: json["id"],
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
    proVendorId: json["pro_vendor_id"],
    proCategoryId: json["pro_category_id"],
    proSubCategoryId: json["pro_sub_category_id"],
    proManuId: json["pro_manu_id"],
    proTax: json["pro_tax"],
    proIsactive: json["pro_isactive"],
    proIsdeleted: json["pro_isdeleted"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    procosProductId: json["procos_product_id"],
    procosVendorId: json["procos_vendor_id"],
    procosMrp: json["procos_mrp"],
    procosSellingPrice: json["procos_selling_price"],
    procosVendorPrice: json["procos_vendor_price"],
    procosAdminMargin: json["procos_admin_margin"],
    procosIsflat: json["procos_isflat"],
  );

  Map<String, dynamic> toMap() => {
    "Productid": productid,
    "id": id,
    "pro_name": proName,
    "pro_description": proDescription,
    "pro_capacity": proCapacity,
    "pro_code": proCode,
    "pro_sku": proSku,
    "package_items_count": packageItemsCount,
    "pro_image_path": proImagePath,
    "pro_unit": proUnit,
    "pro_featured": proFeatured,
    "pro_item_grade": proItemGrade,
    "pro_isoutofstock": proIsoutofstock,
    "pro_vendor_id": proVendorId,
    "pro_category_id": proCategoryId,
    "pro_sub_category_id": proSubCategoryId,
    "pro_manu_id": proManuId,
    "pro_tax": proTax,
    "pro_isactive": proIsactive,
    "pro_isdeleted": proIsdeleted,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "procos_product_id": procosProductId,
    "procos_vendor_id": procosVendorId,
    "procos_mrp": procosMrp,
    "procos_selling_price": procosSellingPrice,
    "procos_vendor_price": procosVendorPrice,
    "procos_admin_margin": procosAdminMargin,
    "procos_isflat": procosIsflat,
  };
}
