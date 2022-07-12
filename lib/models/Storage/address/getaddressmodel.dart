// To parse this JSON data, do
//
//     final getAddressResponseModel = getAddressResponseModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetAddressResponseModel getAddressResponseModelFromMap(String str) => GetAddressResponseModel.fromMap(json.decode(str));

String getAddressResponseModelToMap(GetAddressResponseModel data) => json.encode(data.toMap());

class GetAddressResponseModel {
  GetAddressResponseModel({
    required this.addresses,
  });

  List<Address> addresses;

  factory GetAddressResponseModel.fromMap(Map<String, dynamic> json) => GetAddressResponseModel(
    addresses: List<Address>.from(json["Addresses"].map((x) => Address.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "Addresses": List<dynamic>.from(addresses.map((x) => x.toMap())),
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
    required this.addIsactive,
    required this.addIsdeleted,
    required this.cityName,
    required this.cityStateId,
    required this.cityIsactive,
    required this.cityIsdeleted,
    required this.stateName,
    required this.stateIsactive,
    required this.stateIsdeleted,
  });

  int? addressId;
  String? name;
  int? phonenumber;
  int? altPhonenumber;
  String? addDescription;
  String? addAddress;
  int? addCityId;
  int? addPincode;
  String? addLatitude;
  String? addLongitude;
  int? addIsDefault;
  int? addUserId;
  int? addIsactive;
  int? addIsdeleted;
  String? cityName;
  int? cityStateId;
  int? cityIsactive;
  int? cityIsdeleted;
  String? stateName;
  int? stateIsactive;
  int? stateIsdeleted;

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
    addIsactive: json["add_isactive"],
    addIsdeleted: json["add_isdeleted"],
    cityName: json["city_name"],
    cityStateId: json["city_state_id"],
    cityIsactive: json["city_isactive"],
    cityIsdeleted: json["city_isdeleted"],
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
    "add_isactive": addIsactive,
    "add_isdeleted": addIsdeleted,
    "city_name": cityName,
    "city_state_id": cityStateId,
    "city_isactive": cityIsactive,
    "city_isdeleted": cityIsdeleted,
    "state_name": stateName,
    "state_isactive": stateIsactive,
    "state_isdeleted": stateIsdeleted,
  };
}
