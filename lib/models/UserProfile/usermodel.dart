import 'dart:convert';

EditUserModelDetails editUserModelDetailsFromJson(String str) =>
    EditUserModelDetails.fromJson(json.decode(str));

String editUserModelDetailsToJson(EditUserModelDetails data) =>
    json.encode(data.toJson());

class EditUserModelDetails {
  EditUserModelDetails({
    this.name,
    this.email,
    this.phoneNo,
    this.altPhoneNo,
  });

  String? name;
  String? email;
  String? phoneNo;
  String? altPhoneNo;

  factory EditUserModelDetails.fromJson(Map<String, dynamic> json) =>
      EditUserModelDetails(
        name: json["name"],
        email: json["email"],
        phoneNo: json["phone_no"],
        altPhoneNo: json["alt_phone_no"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone_no": phoneNo,
        "alt_phone_no": altPhoneNo,
      };
}

EditProfileResponseModel editProfileResponseModelFromMap(String str) => EditProfileResponseModel.fromMap(json.decode(str));

String editProfileResponseModelToMap(EditProfileResponseModel data) => json.encode(data.toMap());

class EditProfileResponseModel {
  EditProfileResponseModel({
    required this.message,
    required this.success,
  });

  String? message;
  int? success;

  factory EditProfileResponseModel.fromMap(Map<String, dynamic> json) => EditProfileResponseModel(
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "message": message,
    "success": success,
  };
}
