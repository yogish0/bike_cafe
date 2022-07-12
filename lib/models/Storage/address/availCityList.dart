import 'dart:convert';

GetCitiesList getCitiesListFromMap(String str) => GetCitiesList.fromMap(json.decode(str));

String getCitiesListToMap(GetCitiesList data) => json.encode(data.toMap());

class GetCitiesList {
  GetCitiesList({
    required this.cities,
    required this.success,
  });

  List<City> cities;
  int success;

  factory GetCitiesList.fromMap(Map<String, dynamic> json) => GetCitiesList(
    cities: List<City>.from(json["cities"].map((x) => City.fromMap(x))),
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "cities": List<dynamic>.from(cities.map((x) => x.toMap())),
    "success": success,
  };
}

class City {
  City({
    required this.id,
    required this.cityName,
    required this.cityStateId,
    required this.cityIsactive,
    required this.cityIsdeleted,
  });

  int id;
  String cityName;
  int cityStateId;
  int cityIsactive;
  int cityIsdeleted;

  factory City.fromMap(Map<String, dynamic> json) => City(
    id: json["id"],
    cityName: json["city_name"],
    cityStateId: json["city_state_id"],
    cityIsactive: json["city_isactive"],
    cityIsdeleted: json["city_isdeleted"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "city_name": cityName,
    "city_state_id": cityStateId,
    "city_isactive": cityIsactive,
    "city_isdeleted": cityIsdeleted,
  };
}
