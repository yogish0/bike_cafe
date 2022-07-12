// To parse this JSON data, do
//
//     final getProductByIdModel = getProductByIdModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetProductByIdModel getProductByIdModelFromMap(String str) => GetProductByIdModel.fromMap(json.decode(str));

String getProductByIdModelToMap(GetProductByIdModel data) => json.encode(data.toMap());

class GetProductByIdModel {
  GetProductByIdModel({
    required this.products,
    required this.images,
    required this.success,
    required this.message,
  });

  List<Product> products;
  List<dynamic> images;
  int success;
  String message;

  factory GetProductByIdModel.fromMap(Map<String, dynamic> json) => GetProductByIdModel(
    products: List<Product>.from(json["Products"].map((x) => Product.fromMap(x))),
    images: List<dynamic>.from(json["Images"].map((x) => x)),
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "Products": List<dynamic>.from(products.map((x) => x.toMap())),
    "Images": List<dynamic>.from(images.map((x) => x)),
    "success": success,
    "message": message,
  };
}

class Product {
  Product({
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
    required this.proStockCount,
    required this.proVendorId,
    required this.proCategoryId,
    required this.proSubCategoryId,
    required this.proManuId,
    required this.proTax,
    required this.proIsactive,
    required this.proIsdeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.procosMrp,
    required this.procosSellingPrice,
    required this.catName,
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
  dynamic proStockCount;
  int proVendorId;
  int proCategoryId;
  int proSubCategoryId;
  dynamic proManuId;
  int proTax;
  int proIsactive;
  dynamic proIsdeleted;
  DateTime createdAt;
  DateTime updatedAt;
  int procosMrp;
  int procosSellingPrice;
  String catName;

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    productid: json["productid"],
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
    proStockCount: json["pro_stock_count"],
    proVendorId: json["pro_vendor_id"],
    proCategoryId: json["pro_category_id"],
    proSubCategoryId: json["pro_sub_category_id"],
    proManuId: json["pro_manu_id"],
    proTax: json["pro_tax"],
    proIsactive: json["pro_isactive"],
    proIsdeleted: json["pro_isdeleted"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    procosMrp: json["procos_mrp"],
    procosSellingPrice: json["procos_selling_price"],
    catName: json["cat_name"],
  );

  Map<String, dynamic> toMap() => {
    "productid": productid,
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
    "pro_stock_count": proStockCount,
    "pro_vendor_id": proVendorId,
    "pro_category_id": proCategoryId,
    "pro_sub_category_id": proSubCategoryId,
    "pro_manu_id": proManuId,
    "pro_tax": proTax,
    "pro_isactive": proIsactive,
    "pro_isdeleted": proIsdeleted,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "procos_mrp": procosMrp,
    "procos_selling_price": procosSellingPrice,
    "cat_name": catName,
  };
}
