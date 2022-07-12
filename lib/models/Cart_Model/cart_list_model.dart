import 'dart:convert';

CartItemList cartItemListFromMap(String str) =>
    CartItemList.fromMap(json.decode(str));

String cartItemListToMap(CartItemList data) => json.encode(data.toMap());

class CartItemList {
  CartItemList({
    required this.products,
    required this.success,
  });

  List<Product> products;
  int success;

  factory CartItemList.fromMap(Map<String, dynamic> json) => CartItemList(
    products:
    List<Product>.from(json["Products"].map((x) => Product.fromMap(x))),
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "Products": List<dynamic>.from(products.map((x) => x.toMap())),
    "success": success,
  };
}

class Product {
  Product({
    required this.id,
    required this.cartProductId,
    required this.cartUserId,
    required this.cartQuantity,
    required this.cartIsactive,
    required this.cartIsdeleted,
  });

  int id;
  int cartProductId;
  int cartUserId;
  int cartQuantity;
  int cartIsactive;
  int cartIsdeleted;

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    id: json["id"],
    cartProductId: json["cart_product_id"],
    cartUserId: json["cart_user_id"],
    cartQuantity: json["cart_quantity"],
    cartIsactive: json["cart_isactive"],
    cartIsdeleted: json["cart_isdeleted"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "cart_product_id": cartProductId,
    "cart_user_id": cartUserId,
    "cart_quantity": cartQuantity,
    "cart_isactive": cartIsactive,
    "cart_isdeleted": cartIsdeleted,
  };
}
