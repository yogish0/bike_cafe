// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:get/route_manager.dart';
//
// class NotificationController extends GetxController {
//   void sendNotification() {
//     AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
//       if (!isAllowed) {
//         AwesomeNotifications().requestPermissionToSendNotifications();
//       }
//     });
//
//     AwesomeNotifications().createNotification(
//       content: NotificationContent(
//           id: 1,
//           channelKey: 'test_channel',
//           title: 'Title of the notification.',
//           body: 'Hello! This is the body of the notification.'),
//     );
//
//     // AwesomeNotifications().actionStream.listen((event) {
//     //   Get.to(const Home());
//     // });
//   }
// }
