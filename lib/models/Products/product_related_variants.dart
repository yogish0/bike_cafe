import 'dart:convert';

GetProductRelatedVariant getProductRelatedVariantFromMap(String str) => GetProductRelatedVariant.fromMap(json.decode(str));

String getProductRelatedVariantToMap(GetProductRelatedVariant data) => json.encode(data.toMap());

class GetProductRelatedVariant {
  GetProductRelatedVariant({
    required this.variants,
    required this.message,
    required this.success,
  });

  List<Variant> variants;
  String message;
  int success;

  factory GetProductRelatedVariant.fromMap(Map<String, dynamic> json) => GetProductRelatedVariant(
    variants: List<Variant>.from(json["Variants"].map((x) => Variant.fromMap(x))),
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "Variants": List<dynamic>.from(variants.map((x) => x.toMap())),
    "message": message,
    "success": success,
  };
}

class Variant {
  Variant({
    required this.id,
    required this.vehvarName,
    required this.vehvarCode,
    required this.vehvarCc,
    required this.vehvarModelId,
    required this.vehvarLaunchYear,
    required this.vehvarEndYear,
    required this.vehmodIsactive,
    required this.vehmodIsdelete,
  });

  int id;
  String vehvarName;
  dynamic vehvarCode;
  String vehvarCc;
  int vehvarModelId;
  int vehvarLaunchYear;
  dynamic vehvarEndYear;
  int vehmodIsactive;
  int vehmodIsdelete;

  factory Variant.fromMap(Map<String, dynamic> json) => Variant(
    id: json["id"],
    vehvarName: json["vehvar_name"],
    vehvarCode: json["vehvar_code"],
    vehvarCc: json["vehvar_cc"],
    vehvarModelId: json["vehvar_model_id"],
    vehvarLaunchYear: json["vehvar_launch_year"],
    vehvarEndYear: json["vehvar_end_year"],
    vehmodIsactive: json["vehmod_isactive"],
    vehmodIsdelete: json["vehmod_isdelete"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "vehvar_name": vehvarName,
    "vehvar_code": vehvarCode,
    "vehvar_cc": vehvarCc,
    "vehvar_model_id": vehvarModelId,
    "vehvar_launch_year": vehvarLaunchYear,
    "vehvar_end_year": vehvarEndYear,
    "vehmod_isactive": vehmodIsactive,
    "vehmod_isdelete": vehmodIsdelete,
  };
}
