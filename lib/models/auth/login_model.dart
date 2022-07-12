import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  LoginResponseModel({
    this.apiToken,
    this.user,
    this.message,
    this.success,
  });

  String? apiToken;
  User? user;
  String? message;
  int? success;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        apiToken: json["api_token"],
        user: User.fromJson(json["user"]),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "api_token": apiToken,
        "user": user!.toJson(),
        "message": message,
        "success": success,
      };
}

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.phonenumber,
    this.profilePhotoPath,
    this.createdAt,
    this.updatedAt,
    this.roles,
    this.addresses,
  });

  int? id;
  String? name;
  String? email;
  int? phonenumber;
  dynamic profilePhotoPath;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? roles;
  List<dynamic>? addresses;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phonenumber: json["phonenumber"],
        profilePhotoPath: json["profile_photo_path"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        roles: List<dynamic>.from(json["roles"].map((x) => x)),
        addresses: List<dynamic>.from(json["addresses"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phonenumber": phonenumber,
        "profile_photo_path": profilePhotoPath,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "roles": List<dynamic>.from(roles!.map((x) => x)),
        "addresses": List<dynamic>.from(addresses!.map((x) => x)),
      };
}

class LoginRequestModel {
  String? email;
  String? password;
  // String? loginType;
  String? deviceToken;
  String? andriod_id;
  String? web_id;



  LoginRequestModel({this.email, this.password, this.andriod_id,this.web_id});

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    // loginType = json['loginType'];
    deviceToken = json['device_token'];
    andriod_id = json['android_id'];
    web_id = json['web_id'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    // data['login_type'] = this.loginType;
    data['device_token'] = this.deviceToken;
    data['android_id'] = this.andriod_id;
    data['web_id'] = this.web_id;

    return data;
  }
}

// class LoginMobileRequestModel {
//   String? email;

//   String? password;
//   String? loginType;

//   LoginMobileRequestModel({this.email, this.password, this.loginType});

//   LoginMobileRequestModel.fromJson(Map<String, dynamic> json) {
//     email = json['email'];

//     password = json['password'];
//     // loginType = json['loginType'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['email'] = this.email;

//     data['password'] = this.password;
//     // data['login_type'] = this.loginType;
//     return data;
//   }
// }
