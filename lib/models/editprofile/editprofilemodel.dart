import 'dart:convert';

EditUserResponseModel editUserResponseModelFromJson(String str) =>
    EditUserResponseModel.fromJson(json.decode(str));

String editUserResponseModelToJson(EditUserResponseModel data) =>
    json.encode(data.toJson());

class EditUserResponseModel {
  EditUserResponseModel({
    this.message,
    this.success,
  });

  String? message;
  int? success;

  factory EditUserResponseModel.fromJson(Map<String, dynamic> json) =>
      EditUserResponseModel(
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
      };
}

EditUserModel editUserModelFromJson(String str) =>
    EditUserModel.fromJson(json.decode(str));

String editUserModelToJson(EditUserModel data) => json.encode(data.toJson());

class EditUserModel {
  EditUserModel({
    this.name,
    this.email,
    this.phoneNo,
  });

  String? name;
  String? email;
  String? phoneNo;

  factory EditUserModel.fromJson(Map<String, dynamic> json) => EditUserModel(
        name: json["name"],
        email: json["email"],
        phoneNo: json["phone_no"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone_no": phoneNo,
      };
}
