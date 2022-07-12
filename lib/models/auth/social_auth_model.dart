import 'dart:convert';

SocialAuthModel socialAuthModelFromMap(String str) => SocialAuthModel.fromMap(json.decode(str));

class SocialAuthModel {
  SocialAuthModel({
    this.apiToken,
    this.user,
    this.message,
    this.success,
  });

  String? apiToken;
  User? user;
  String? message;
  int? success;

  factory SocialAuthModel.fromMap(Map<String, dynamic> json) => SocialAuthModel(
    apiToken: json["api_token"],
    user: User.fromMap(json["user"]),
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "api_token": apiToken,
    "user": user,
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
    this.userGoogleId,
    this.userGoogleTypeId,
    this.userFacebookId,
    this.userFacebookTypeId,
    this.profilePhotoPath,
    this.usersIsactive,
    this.usersIsdeleted,
  });

  int? id;
  String? name;
  String? email;
  int? phonenumber;
  String? userGoogleId;
  String? userGoogleTypeId;
  dynamic userFacebookId;
  dynamic userFacebookTypeId;
  dynamic profilePhotoPath;
  int? usersIsactive;
  int? usersIsdeleted;

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phonenumber: json["phonenumber"],
    userGoogleId: json["user_google_id"],
    userGoogleTypeId: json["user_google_type_id"],
    userFacebookId: json["user_facebook_id"],
    userFacebookTypeId: json["user_facebook_type_id"],
    profilePhotoPath: json["profile_photo_path"],
    usersIsactive: json["users_isactive"],
    usersIsdeleted: json["users_isdeleted"],
  );
}


//social auth check model to check user is exist or new user
SocialAuthCheckUserModel socialAuthCheckUserModelFromMap(String str) => SocialAuthCheckUserModel.fromMap(json.decode(str));

class SocialAuthCheckUserModel {
  SocialAuthCheckUserModel({
    this.isavailable,
    this.message,
    this.success,
  });

  String? isavailable;
  String? message;
  String? success;

  factory SocialAuthCheckUserModel.fromMap(Map<String, dynamic> json) => SocialAuthCheckUserModel(
    isavailable: json["isavailable"],
    message: json["message"],
    success: json["success"],
  );
}
