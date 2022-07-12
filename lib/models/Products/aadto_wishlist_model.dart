// To parse this JSON data, do
//
//     final addToWishlist = addToWishlistFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AddToWishlist addToWishlistFromMap(String str) => AddToWishlist.fromMap(json.decode(str));

String addToWishlistToMap(AddToWishlist data) => json.encode(data.toMap());

class AddToWishlist {
  AddToWishlist({
    required this.wishlist,
    required this.success,
  });

  Wishlist wishlist;
  int success;

  factory AddToWishlist.fromMap(Map<String, dynamic> json) => AddToWishlist(
    wishlist: Wishlist.fromMap(json["wishlist"]),
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "wishlist": wishlist.toMap(),
    "success": success,
  };
}

class Wishlist {
  Wishlist({
    required this.message,
  });

  String message;

  factory Wishlist.fromMap(Map<String, dynamic> json) => Wishlist(
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "message": message,
  };
}
