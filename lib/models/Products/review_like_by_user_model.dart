import 'dart:convert';

ReviewsLikesDislikesModel reviewsLikesDislikesModelFromMap(String str) => ReviewsLikesDislikesModel.fromMap(json.decode(str));

class ReviewsLikesDislikesModel {
  ReviewsLikesDislikesModel({
    required this.review,
    required this.message,
    required this.success,
  });

  List<Review> review;
  String? message;
  String? success;

  factory ReviewsLikesDislikesModel.fromMap(Map<String, dynamic> json) => ReviewsLikesDislikesModel(
    review: List<Review>.from(json["Review"].map((x) => Review.fromMap(x))),
    message: json["message"],
    success: json["success"],
  );
}

class Review {
  Review({
    required this.proLike,
    required this.proDislike,
  });

  int? proLike;
  int? proDislike;

  factory Review.fromMap(Map<String, dynamic> json) => Review(
    proLike: json["pro_like"],
    proDislike: json["pro_dislike"],
  );
}
