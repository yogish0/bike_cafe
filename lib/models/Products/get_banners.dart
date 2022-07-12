
import 'dart:convert';

GetBanners getBannersFromMap(String str) => GetBanners.fromMap(json.decode(str));

String getBannersToMap(GetBanners data) => json.encode(data.toMap());

class GetBanners {
  GetBanners({
    required this.body,
    required this.success,
  });

  List<Body> body;
  String success;

  factory GetBanners.fromMap(Map<String, dynamic> json) => GetBanners(
    body: List<Body>.from(json["body"].map((x) => Body.fromMap(x))),
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "body": List<dynamic>.from(body.map((x) => x.toMap())),
    "success": success,
  };
}

class Body {
  Body({
    required this.id,
    required this.bannerImageUrl,
    required this.bannerDescprition,
    required this.isActive,
    required this.isDeleted,
  });

  int id;
  String? bannerImageUrl;
  String? bannerDescprition;
  int? isActive;
  int? isDeleted;

  factory Body.fromMap(Map<String, dynamic> json) => Body(
    id: json["id"],
    bannerImageUrl: json["banner_image_url"],
    bannerDescprition: json["banner_descprition"],
    isActive: json["is_active"],
    isDeleted: json["is_deleted"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "banner_image_url": bannerImageUrl,
    "banner_descprition": bannerDescprition,
    "is_active": isActive,
    "is_deleted": isDeleted,
  };
}
