import 'dart:convert';

GetNotificationModel getNotificationModelFromMap(String str) => GetNotificationModel.fromMap(json.decode(str));

class GetNotificationModel {
  GetNotificationModel({
    required this.notification,
    required this.message,
    required this.success,
  });

  List<Notification> notification;
  String message;
  int success;

  factory GetNotificationModel.fromMap(Map<String, dynamic> json) => GetNotificationModel(
    notification: List<Notification>.from(json["Notification"].map((x) => Notification.fromMap(x))),
    message: json["message"],
    success: json["success"],
  );
}

class Notification {
  Notification({
    required this.id,
    required this.userId,
    required this.notificationTitle,
    required this.notificationMsg,
    required this.channelId,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int userId;
  dynamic notificationTitle;
  String notificationMsg;
  int channelId;
  DateTime createdAt;
  DateTime updatedAt;

  factory Notification.fromMap(Map<String, dynamic> json) => Notification(
    id: json["id"],
    userId: json["user_id"],
    notificationTitle: json["notification_title"],
    notificationMsg: json["notification_msg"],
    channelId: json["channel_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );
}
