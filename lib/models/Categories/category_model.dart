// To parse this JSON data, do
//
//     final getCategories = getCategoriesFromMap(jsonString);
import 'dart:convert';

GetCategories getCategoriesFromMap(String str) =>
    GetCategories.fromMap(json.decode(str));

String getCategoriesToMap(GetCategories data) => json.encode(data.toMap());

class GetCategories {
  GetCategories({
    required this.categories,
    required this.message,
    required this.success,
  });

  List<Category> categories;
  String? message;
  int success;

  factory GetCategories.fromMap(Map<String, dynamic> json) => GetCategories(
    categories: List<Category>.from(
        json["Categories"].map((x) => Category.fromMap(x))),
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "Categories": List<dynamic>.from(categories.map((x) => x.toMap())),
    "message": message,
    "success": success,
  };
}

class Category {
  Category({
    required this.id,
    required this.catName,
    required this.catDescription,
    required this.catImagepath,
    required this.catIsactive,
    required this.catIsdeleted,
    required this.catIssubcategory,
  });

  int id;
  String? catName;
  String? catDescription;
  String? catImagepath;
  int? catIsactive;
  int? catIsdeleted;
  int? catIssubcategory;

  factory Category.fromMap(Map<String, dynamic> json) => Category(
    id: json["id"],
    catName: json["cat_name"],
    catDescription: json["cat_description"],
    catImagepath: json["cat_imagepath"],
    catIsactive: json["cat_isactive"],
    catIsdeleted: json["cat_isdeleted"],
    catIssubcategory: json["cat_issubcategory"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "cat_name": catName,
    "cat_description": catDescription,
    "cat_imagepath": catImagepath,
    "cat_isactive": catIsactive,
    "cat_isdeleted": catIsdeleted,
    "cat_issubcategory": catIssubcategory,
  };
}
