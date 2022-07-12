// To parse this JSON data, do
//
//     final getProducts = getProductsFromMap(jsonString);
import 'dart:convert';

GetProducts getProductsFromMap(String str) =>
    GetProducts.fromMap(json.decode(str));

String getProductsToMap(GetProducts data) => json.encode(data.toMap());

class GetProducts {
  GetProducts({
    required this.products,
    required this.success,
    required this.message,
  });

  List<Product> products;
  int success;
  String message;

  factory GetProducts.fromMap(Map<String, dynamic> json) => GetProducts(
    products:
    List<Product>.from(json["Products"].map((x) => Product.fromMap(x))),
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "Products": List<dynamic>.from(products.map((x) => x.toMap())),
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
    required this.proVendorId,
    required this.proCategoryId,
    required this.proSubCategoryId,
    required this.proManuId,
    required this.proTax,
    required this.proIsactive,
    required this.proIsdeleted,
    required this.procosProductId,
    required this.procosVendorId,
    required this.procosMrp,
    required this.procosSellingPrice,
    required this.procosVendorPrice,
    required this.procosAdminMargin,
    required this.procosIsflat,
    required this.catName,
  });

  int? productid;
  int? id;
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
  int? proVendorId;
  int? proCategoryId;
  int? proSubCategoryId;
  int? proManuId;
  int? proTax;
  int? proIsactive;
  int? proIsdeleted;
  int? procosProductId;
  int? procosVendorId;
  dynamic procosMrp;
  dynamic procosSellingPrice;
  dynamic procosVendorPrice;
  dynamic procosAdminMargin;
  int? procosIsflat;
  String? catName;

  factory Product.fromMap(Map<String, dynamic> json) => Product(
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
    procosProductId: json["procos_product_id"],
    procosVendorId: json["procos_vendor_id"],
    procosMrp: json["procos_mrp"],
    procosSellingPrice: json["procos_selling_price"],
    procosVendorPrice: json["procos_vendor_price"],
    procosAdminMargin: json["procos_admin_margin"],
    procosIsflat: json["procos_isflat"],
    catName: json["cat_name"],
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
    "procos_product_id": procosProductId,
    "procos_vendor_id": procosVendorId,
    "procos_mrp": procosMrp,
    "procos_selling_price": procosSellingPrice,
    "procos_vendor_price": procosVendorPrice,
    "procos_admin_margin": procosAdminMargin,
    "procos_isflat": procosIsflat,
    "cat_name" : catName
  };
}
