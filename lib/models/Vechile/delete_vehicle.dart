import 'dart:convert';

DeleteVehicleById deleteVehicleByIdFromMap(String str) => DeleteVehicleById.fromMap(json.decode(str));

String deleteVehicleByIdToMap(DeleteVehicleById data) => json.encode(data.toMap());

class DeleteVehicleById {
  DeleteVehicleById({
    required this.message,
    required this.success,
  });

  String? message;
  int? success;

  factory DeleteVehicleById.fromMap(Map<String, dynamic> json) => DeleteVehicleById(
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "message": message,
    "success": success,
  };
}
