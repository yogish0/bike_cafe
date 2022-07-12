import 'dart:convert';

CheckWishlisted checkWishlistedFromMap(String str) => CheckWishlisted.fromMap(json.decode(str));

String checkWishlistedToMap(CheckWishlisted data) => json.encode(data.toMap());

class CheckWishlisted {
  CheckWishlisted({
    required this.checkout,
    required this.success,
  });

  Checkout checkout;
  String success;

  factory CheckWishlisted.fromMap(Map<String, dynamic> json) => CheckWishlisted(
    checkout: Checkout.fromMap(json["checkout"]),
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "checkout": checkout.toMap(),
    "success": success,
  };
}

class Checkout {
  Checkout({
    required this.iswishlist,
    required this.message,
    required this.success,
  });

  int iswishlist;
  String message;
  int success;

  factory Checkout.fromMap(Map<String, dynamic> json) => Checkout(
    iswishlist: json["iswishlist"],
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "iswishlist": iswishlist,
    "message": message,
    "success": success,
  };
}
