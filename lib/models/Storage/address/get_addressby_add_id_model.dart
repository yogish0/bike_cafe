import 'dart:convert';

GetAddressbyAddId getAddressbyAddIdFromMap(String str) => GetAddressbyAddId.fromMap(json.decode(str));

String getAddressbyAddIdToMap(GetAddressbyAddId data) => json.encode(data.toMap());

class GetAddressbyAddId {
  GetAddressbyAddId({
    required this.address,
    required this.success,
  });

  List<Address> address;
  int success;

  factory GetAddressbyAddId.fromMap(Map<String, dynamic> json) => GetAddressbyAddId(
    address: List<Address>.from(json["Address"].map((x) => Address.fromMap(x))),
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "Address": List<dynamic>.from(address.map((x) => x.toMap())),
    "success": success,
  };
}

class Address {
  Address({
    required this.addressId,
    required this.name,
    required this.phonenumber,
    required this.altPhonenumber,
    required this.addDescription,
    required this.addAddress,
    required this.addCityId,
    required this.addPincode,
    required this.addLatitude,
    required this.addLongitude,
    required this.addIsDefault,
    required this.addUserId,
    required this.cityId,
    required this.id,
    required this.cityName,
    required this.cityStateId,
    required this.cityIsactive,
    required this.cityIsdeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.stateName,
    required this.stateIsactive,
    required this.stateIsdeleted,
  });

  int addressId;
  String name;
  int phonenumber;
  dynamic altPhonenumber;
  String addDescription;
  String addAddress;
  int addCityId;
  int addPincode;
  String addLatitude;
  String addLongitude;
  int addIsDefault;
  int addUserId;
  int cityId;
  int id;
  String cityName;
  int cityStateId;
  int cityIsactive;
  int cityIsdeleted;
  DateTime createdAt;
  DateTime updatedAt;
  String stateName;
  int stateIsactive;
  int stateIsdeleted;

  factory Address.fromMap(Map<String, dynamic> json) => Address(
    addressId: json["address_id"],
    name: json["name"],
    phonenumber: json["phonenumber"],
    altPhonenumber: json["alt_phonenumber"],
    addDescription: json["add_description"],
    addAddress: json["add_address"],
    addCityId: json["add_city_id"],
    addPincode: json["add_pincode"],
    addLatitude: json["add_latitude"],
    addLongitude: json["add_longitude"],
    addIsDefault: json["add_is_default"],
    addUserId: json["add_user_id"],
    cityId: json["city id"],
    id: json["id"],
    cityName: json["city_name"],
    cityStateId: json["city_state_id"],
    cityIsactive: json["city_isactive"],
    cityIsdeleted: json["city_isdeleted"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    stateName: json["state_name"],
    stateIsactive: json["state_isactive"],
    stateIsdeleted: json["state_isdeleted"],
  );

  Map<String, dynamic> toMap() => {
    "address_id": addressId,
    "name": name,
    "phonenumber": phonenumber,
    "alt_phonenumber": altPhonenumber,
    "add_description": addDescription,
    "add_address": addAddress,
    "add_city_id": addCityId,
    "add_pincode": addPincode,
    "add_latitude": addLatitude,
    "add_longitude": addLongitude,
    "add_is_default": addIsDefault,
    "add_user_id": addUserId,
    "city id": cityId,
    "id": id,
    "city_name": cityName,
    "city_state_id": cityStateId,
    "city_isactive": cityIsactive,
    "city_isdeleted": cityIsdeleted,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "state_name": stateName,
    "state_isactive": stateIsactive,
    "state_isdeleted": stateIsdeleted,
  };
}
