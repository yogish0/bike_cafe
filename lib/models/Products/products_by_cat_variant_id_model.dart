import 'dart:convert';

GetProductsByCatAndVarientIdModel getProductsByCatAndVarientIdModelFromMap(String str) => GetProductsByCatAndVarientIdModel.fromMap(json.decode(str));

String getProductsByCatAndVarientIdModelToMap(GetProductsByCatAndVarientIdModel data) => json.encode(data.toMap());

class GetProductsByCatAndVarientIdModel {
  GetProductsByCatAndVarientIdModel({
    required this.products,
    required this.success,
    required this.message,
  });

  List<Product> products;
  int? success;
  String? message;

  factory GetProductsByCatAndVarientIdModel.fromMap(Map<String, dynamic> json) => GetProductsByCatAndVarientIdModel(
    products: List<Product>.from(json["Products"].map((x) => Product.fromMap(x))),
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
    required this.proName,
    required this.id,
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
    required this.vehvarName,
    required this.vehvarCc,
    required this.procosProductId,
    required this.procosVendorId,
    required this.procosMrp,
    required this.procosSellingPrice,
    required this.procosVendorPrice,
    required this.procosAdminMargin,
    required this.procosIsflat,
    required this.variantid,
  });

  int? productid;
  String? proName;
  int? id;
  String? proDescription;
  int? proCapacity;
  String? proCode;
  String? proSku;
  int? packageItemsCount;
  String? proImagePath;
  String? proUnit;
  int? proFeatured;
  String? proItemGrade;
  int? proIsoutofstock;
  int? proVendorId;
  int? proCategoryId;
  int? proSubCategoryId;
  dynamic proManuId;
  int? proTax;
  int? proIsactive;
  dynamic proIsdeleted;
  String? vehvarName;
  String? vehvarCc;
  int? procosProductId;
  int? procosVendorId;
  dynamic procosMrp;
  dynamic procosSellingPrice;
  dynamic procosVendorPrice;
  dynamic procosAdminMargin;
  int? procosIsflat;
  int? variantid;

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    productid: json["productid"],
    proName: json["pro_name"],
    id: json["id"],
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
    vehvarName: json["vehvar_name"],
    vehvarCc: json["vehvar_cc"],
    procosProductId: json["procos_product_id"],
    procosVendorId: json["procos_vendor_id"],
    procosMrp: json["procos_mrp"],
    procosSellingPrice: json["procos_selling_price"],
    procosVendorPrice: json["procos_vendor_price"],
    procosAdminMargin: json["procos_admin_margin"],
    procosIsflat: json["procos_isflat"],
    variantid: json["variantid"],
  );

  Map<String, dynamic> toMap() => {
    "productid": productid,
    "pro_name": proName,
    "id": id,
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
    "vehvar_name": vehvarName,
    "vehvar_cc": vehvarCc,
    "procos_product_id": procosProductId,
    "procos_vendor_id": procosVendorId,
    "procos_mrp": procosMrp,
    "procos_selling_price": procosSellingPrice,
    "procos_vendor_price": procosVendorPrice,
    "procos_admin_margin": procosAdminMargin,
    "procos_isflat": procosIsflat,
    "variantid": variantid,
  };
}
