import 'dart:convert';

ProductReviewByUserModel productReviewByUserModelFromMap(String str) => ProductReviewByUserModel.fromMap(json.decode(str));

class ProductReviewByUserModel {
  ProductReviewByUserModel({
    required this.reviewid,
    required this.message,
    required this.success,
  });

  int? reviewid;
  String? message;
  String? success;

  factory ProductReviewByUserModel.fromMap(Map<String, dynamic> json) => ProductReviewByUserModel(
    reviewid: json["Reviewid"],
    message: json["message"],
    success: json["success"],
  );
}
