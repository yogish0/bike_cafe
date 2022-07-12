import 'dart:convert';

GetUsersProductReview getUsersProductReviewFromMap(String str) => GetUsersProductReview.fromMap(json.decode(str));

class GetUsersProductReview {
  GetUsersProductReview({
    required this.reviews,
    required this.message,
    required this.success,
  });

  List<Review> reviews;
  String? message;
  int? success;

  factory GetUsersProductReview.fromMap(Map<String, dynamic> json) => GetUsersProductReview(
    reviews: List<Review>.from(json["Reviews"].map((x) => Review.fromMap(x))),
    message: json["message"],
    success: json["success"],
  );
}

class Review {
  Review({
    required this.reviewid,
    required this.username,
    required this.id,
    required this.prorevReview,
    required this.prorevDescription,
    required this.prorevRate,
    required this.prorevUserId,
    required this.prorevProductId,
    required this.prorevProductImg,
  });

  int? reviewid;
  String? username;
  int? id;
  String? prorevReview;
  dynamic prorevDescription;
  int? prorevRate;
  int? prorevUserId;
  int? prorevProductId;
  String? prorevProductImg;

  factory Review.fromMap(Map<String, dynamic> json) => Review(
    reviewid: json["Reviewid"],
    username: json["Username"],
    id: json["id"],
    prorevReview: json["prorev_review"],
    prorevDescription: json["prorev_description"],
    prorevRate: json["prorev_rate"],
    prorevUserId: json["prorev_user_id"],
    prorevProductId: json["prorev_product_id"],
    prorevProductImg: json["prorev_product_img"],
  );
}
