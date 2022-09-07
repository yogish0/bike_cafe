import 'package:flutter/material.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';
import 'package:hive/hive.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../models/Notifications/get_notification_model.dart';
import '../../../services/api.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Box? box1;

  @override
  void initState() {
    super.initState();

    createBox();
  }

  void createBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {});
  }

  APIService service = APIService();

  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      index: 6,
      title: "Notification",
      body: Container(
        margin: const EdgeInsets.only(top: 4),
        child: FutureBuilder<GetNotificationModel?>(
          future: service.getNotificationApi(
              token: box1?.get('data4'), userId: box1?.get('data3')),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data != null) {
              return ListView.builder(
                  itemCount: snapshot.data?.notification.length,
                  itemBuilder: (context, index) {
                    var notificationData = snapshot.data!.notification[index];
                    return ListTile(
                      visualDensity: const VisualDensity(vertical: 4),
                      tileColor: Colors.white70,
                      leading: notificationLogo(),
                      title:
                          Text(notificationData.notificationTitle.toString()),
                      subtitle:
                          Text(notificationData.notificationMsg.toString()),
                      trailing: Text(
                        timeago.format(notificationData.createdAt.toLocal(),
                            locale: 'en_short'),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  });
            } else {
              return const Center(child: Text("No notifications"));
            }
          },
        ),
      ),
    );
  }

  Widget notificationLogo() {
    return ClipOval(
      child: Container(
        color: kPrimaryColor,
        height: 50,
        width: 50,
        child: const Icon(Icons.notifications, color: Colors.white),
      ),
    );
  }
}
