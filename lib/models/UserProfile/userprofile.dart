import 'dart:convert';

GetUserProfileData getUserProfileDataFromMap(String str) => GetUserProfileData.fromMap(json.decode(str));

String getUserProfileDataToMap(GetUserProfileData data) => json.encode(data.toMap());

class GetUserProfileData {
  GetUserProfileData({
    required this.user,
    required this.success,
  });

  List<User> user;
  int success;

  factory GetUserProfileData.fromMap(Map<String, dynamic> json) => GetUserProfileData(
    user: List<User>.from(json["user"].map((x) => User.fromMap(x))),
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "user": List<dynamic>.from(user.map((x) => x.toMap())),
    "success": success,
  };
}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phonenumber,
    required this.userGoogleId,
    required this.userGoogleTypeId,
    required this.userFacebookId,
    required this.userFacebookTypeId,
    required this.profilePhotoPath,
    required this.usersIsactive,
    required this.usersIsdeleted,
  });

  int id;
  String name;
  String email;
  int phonenumber;
  dynamic userGoogleId;
  dynamic userGoogleTypeId;
  dynamic userFacebookId;
  dynamic userFacebookTypeId;
  String? profilePhotoPath;
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

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "phonenumber": phonenumber,
    "user_google_id": userGoogleId,
    "user_google_type_id": userGoogleTypeId,
    "user_facebook_id": userFacebookId,
    "user_facebook_type_id": userFacebookTypeId,
    "profile_photo_path": profilePhotoPath,
    "users_isactive": usersIsactive,
    "users_isdeleted": usersIsdeleted,
  };
}
