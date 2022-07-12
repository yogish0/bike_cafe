import 'dart:convert';

PostAddressModel postAddressModelFromJson(String? str) =>
    PostAddressModel.fromJson(json.decode(str!));

String? postAddressModelToJson(PostAddressModel data) =>
    json.encode(data.toJson());

class PostAddressModel {
  PostAddressModel({
    this.address,
    this.description,
    this.cityId,
    this.pincode,
    this.lattitude,
    this.longitude,
    this.defaultAddress,
  });

  String? address;
  String? description;
  String? cityId;
  String? pincode;
  String? lattitude;
  String? longitude;
  String? defaultAddress;

  factory PostAddressModel.fromJson(Map<String?, dynamic> json) =>
      PostAddressModel(
        address: json["address"],
        description: json["description"],
        cityId: json["city_id"],
        pincode: json["pincode"],
        lattitude: json["lattitude"],
        longitude: json["longitude"],
        defaultAddress: json["default_address"],
      );

  Map<String?, dynamic> toJson() => {
        "address": address,
        "description": description,
        "city_id": cityId,
        "pincode": pincode,
        "lattitude": lattitude,
        "longitude": longitude,
        "default_address": defaultAddress,
      };
}
// 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

SetDefaultAddress setDefaultAddressFromMap(String str) => SetDefaultAddress.fromMap(json.decode(str));

String setDefaultAddressToMap(SetDefaultAddress data) => json.encode(data.toMap());

class SetDefaultAddress {
  SetDefaultAddress({
    required this.message,
  });

  String message;

  factory SetDefaultAddress.fromMap(Map<String, dynamic> json) => SetDefaultAddress(
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "message": message,
  };
}

PostAddressResponseModel postAddressResponseModelFromMap(String str) => PostAddressResponseModel.fromMap(json.decode(str));

String postAddressResponseModelToMap(PostAddressResponseModel data) => json.encode(data.toMap());

class PostAddressResponseModel {
  PostAddressResponseModel({
    required this.message,
    required this.success,
  });

  String? message;
  int? success;

  factory PostAddressResponseModel.fromMap(Map<String, dynamic> json) => PostAddressResponseModel(
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "message": message,
    "success": success,
  };
}