import 'dart:convert';

AddCartItem addCartItemFromMap(String str) =>
    AddCartItem.fromMap(json.decode(str));

String addCartItemToMap(AddCartItem data) => json.encode(data.toMap());

class AddCartItem {
  AddCartItem({
    required this.cart,
    required this.success,
  });

  Cart cart;
  int? success;

  factory AddCartItem.fromMap(Map<String, dynamic> json) => AddCartItem(
    cart: Cart.fromMap(json["cart"]),
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "cart": cart.toMap(),
    "success": success,
  };
}

class Cart {
  Cart({
    required this.message,
    required this.success,
  });

  String message;
  dynamic success;

  factory Cart.fromMap(Map<String, dynamic> json) => Cart(
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "message": message,
    "success": success,
  };
}
