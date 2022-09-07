import 'dart:convert';

GetProductReviewAndRatingModel getProductReviewAndRatingModelFromMap(String str) => GetProductReviewAndRatingModel.fromMap(json.decode(str));

String getProductReviewAndRatingModelToMap(GetProductReviewAndRatingModel data) => json.encode(data.toMap());

class GetProductReviewAndRatingModel {
  GetProductReviewAndRatingModel({
    required this.productreview,
    required this.avgRating,
    required this.numofrating1,
    required this.numofrating2,
    required this.numofrating3,
    required this.numofrating4,
    required this.numofrating5,
    required this.totaltrating,
    required this.totaltreview,
  });

  List<Productreview> productreview;
  AvgRating avgRating;
  Totaltrating? totaltrating;
  Totaltreview? totaltreview;
  Numofrating1? numofrating1;
  Numofrating2? numofrating2;
  Numofrating3? numofrating3;
  Numofrating4? numofrating4;
  Numofrating5? numofrating5;

  factory GetProductReviewAndRatingModel.fromMap(Map<String, dynamic> json) => GetProductReviewAndRatingModel(
    productreview: List<Productreview>.from(json["productreview"].map((x) => Productreview.fromMap(x))),
    avgRating: AvgRating.fromMap(json["avg_rating"]),
    totaltrating: Totaltrating.fromMap(json["totaltrating"]),
    totaltreview: Totaltreview.fromMap(json["totaltreview"]),
    numofrating1: Numofrating1.fromMap(json["numofrating1"]),
    numofrating2: Numofrating2.fromMap(json["numofrating2"]),
    numofrating3: Numofrating3.fromMap(json["numofrating3"]),
    numofrating4: Numofrating4.fromMap(json["numofrating4"]),
    numofrating5: Numofrating5.fromMap(json["numofrating5"]),
  );

  Map<String, dynamic> toMap() => {
    "productreview": List<dynamic>.from(productreview.map((x) => x.toMap())),
    "avg_rating": avgRating.toMap(),
    "totaltrating": totaltrating?.toMap(),
    "totaltreview": totaltreview?.toMap(),
    "numofrating1": numofrating1?.toMap(),
    "numofrating2": numofrating2?.toMap(),
    "numofrating3": numofrating3?.toMap(),
    "numofrating4": numofrating4?.toMap(),
    "numofrating5": numofrating5?.toMap(),
  };
}

class AvgRating {
  AvgRating({
    this.avgRating,
  });

  String? avgRating;

  factory AvgRating.fromMap(Map<String, dynamic> json) => AvgRating(
    avgRating: json["avg_rating"],
  );

  Map<String, dynamic> toMap() => {
    "avg_rating": avgRating,
  };
}

class Numofrating1 {
  Numofrating1({
    this.numofrating1,
  });

  int? numofrating1;

  factory Numofrating1.fromMap(Map<String, dynamic> json) => Numofrating1(
    numofrating1: json["numofrating1"],
  );

  Map<String, dynamic> toMap() => {
    "numofrating1": numofrating1,
  };
}

class Numofrating2 {
  Numofrating2({
    this.numofrating2,
  });

  int? numofrating2;

  factory Numofrating2.fromMap(Map<String, dynamic> json) => Numofrating2(
    numofrating2: json["numofrating2"],
  );

  Map<String, dynamic> toMap() => {
    "numofrating2": numofrating2,
  };
}

class Numofrating3 {
  Numofrating3({
    this.numofrating3,
  });

  int? numofrating3;

  factory Numofrating3.fromMap(Map<String, dynamic> json) => Numofrating3(
    numofrating3: json["numofrating3"],
  );

  Map<String, dynamic> toMap() => {
    "numofrating3": numofrating3,
  };
}

class Numofrating4 {
  Numofrating4({
    this.numofrating4,
  });

  int? numofrating4;

  factory Numofrating4.fromMap(Map<String, dynamic> json) => Numofrating4(
    numofrating4: json["numofrating4"],
  );

  Map<String, dynamic> toMap() => {
    "numofrating4": numofrating4,
  };
}

class Numofrating5 {
  Numofrating5({
    this.numofrating5,
  });

  int? numofrating5;

  factory Numofrating5.fromMap(Map<String, dynamic> json) => Numofrating5(
    numofrating5: json["numofrating5"],
  );

  Map<String, dynamic> toMap() => {
    "numofrating5": numofrating5,
  };
}

class Productreview {
  Productreview({
    this.id,
    this.prorevReview,
    this.prorevDescription,
    this.prorevRate,
    this.prorevUserId,
    this.prorevProductId,
    this.prorevProductImg,
    this.prorevIsactive,
    this.prorevIsdeleted,
    this.username,
    this.prorevLike,
    this.prorevDislike,
  });

  int? id;
  String? prorevReview;
  String? prorevDescription;
  int? prorevRate;
  int? prorevUserId;
  int? prorevProductId;
  String? prorevProductImg;
  int? prorevIsactive;
  int? prorevIsdeleted;
  String? username;
  int? prorevLike;
  int? prorevDislike;

  factory Productreview.fromMap(Map<String, dynamic> json) => Productreview(
    id: json["id"],
    prorevReview: json["prorev_review"],
    prorevDescription: json["prorev_description"],
    prorevRate: json["prorev_rate"],
    prorevUserId: json["prorev_user_id"],
    prorevProductId: json["prorev_product_id"],
    prorevProductImg: json["prorev_product_img"],
    prorevIsactive: json["prorev_isactive"],
    prorevIsdeleted: json["prorev_isdeleted"],
    username: json["Username"],
    prorevLike: json["prorev_like"],
    prorevDislike: json["prorev_dislike"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "prorev_review": prorevReview,
    "prorev_description": prorevDescription,
    "prorev_rate": prorevRate,
    "prorev_user_id": prorevUserId,
    "prorev_product_id": prorevProductId,
    "prorev_product_img": prorevProductImg,
    "prorev_isactive": prorevIsactive,
    "prorev_isdeleted": prorevIsdeleted,
    "Username": username,
    "prorev_like": prorevLike,
    "prorev_dislike": prorevDislike,
  };
}

class Totaltrating {
  Totaltrating({
    this.totalrate,
  });

  int? totalrate;

  factory Totaltrating.fromMap(Map<String, dynamic> json) => Totaltrating(
    totalrate: json["Totalrate"],
  );

  Map<String, dynamic> toMap() => {
    "Totalrate": totalrate,
  };
}

class Totaltreview {
  Totaltreview({
    required this.totalReview,
  });

  int? totalReview;

  factory Totaltreview.fromMap(Map<String, dynamic> json) => Totaltreview(
    totalReview: json["TotalReview"],
  );

  Map<String, dynamic> toMap() => {
    "TotalReview": totalReview,
  };
}
