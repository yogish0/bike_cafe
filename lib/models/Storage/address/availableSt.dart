// To parse this JSON data, do
//
//     final getStatesList = getStatesListFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetStatesList getStatesListFromMap(String str) => GetStatesList.fromMap(json.decode(str));

String getStatesListToMap(GetStatesList data) => json.encode(data.toMap());

class GetStatesList {
  GetStatesList({
    required this.statelists,
    required this.success,
  });

  List<Statelist> statelists;
  int success;

  factory GetStatesList.fromMap(Map<String, dynamic> json) => GetStatesList(
    statelists: List<Statelist>.from(json["statelists"].map((x) => Statelist.fromMap(x))),
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "statelists": List<dynamic>.from(statelists.map((x) => x.toMap())),
    "success": success,
  };
}

class Statelist {
  Statelist({
    required this.id,
    required this.stateName,
    required this.stateIsactive,
    required this.stateIsdeleted,
  });

  int id;
  String stateName;
  int stateIsactive;
  int stateIsdeleted;

  factory Statelist.fromMap(Map<String, dynamic> json) => Statelist(
    id: json["id"],
    stateName: json["state_name"],
    stateIsactive: json["state_isactive"],
    stateIsdeleted: json["state_isdeleted"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "state_name": stateName,
    "state_isactive": stateIsactive,
    "state_isdeleted": stateIsdeleted,
  };
}
