import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:bike_cafe/routes/routes.dart';
import 'package:bike_cafe/screens/Dashboard/Home/dashboard.dart';
import 'package:bike_cafe/screens/Dashboard/MyOrder/orders_list.dart';
import 'package:bike_cafe/screens/Dashboard/myoffres/myoffers.dart';

import 'package:bike_cafe/screens/SplashScreen/splashScreen.dart';
import 'package:bike_cafe/screens/auth/login/signin.dart';
import 'package:bike_cafe/widget/binding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';

late Box box1;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  Notificationapi.inint();

  await FirebaseMessaging.onMessageOpenedApp.listen((event) {
    debugPrint('on message details is ' + event.data.toString());
    Map valueMap = event.data;
    debugPrint(valueMap['screen']);
    //
    if (box1.get("data4") != null) {
      if (valueMap['screen'] == '1') {
        Get.to(() => const MyOffersPage());
      } else if (valueMap['screen'] == '2') {
        Get.to(() => const OrdersListPage());
      } else {
        Get.to(() => Dashboard());
      }
    } else {
      Get.to(() => const SignIn());
    }
  });

  await Notificationapi.onNotification.stream.listen((event) {
    Map valueMap = event.isEmpty ? {} : json.decode(event as String);

    if (box1.get("data4") != null) {
      if (valueMap['screen'] == '1') {
        Get.to(() => const MyOffersPage());
      } else if (valueMap['screen'] == '2') {
        Get.to(() => const OrdersListPage());
      } else {
        Get.to(() => Dashboard());
      }
    } else {
      Get.to(() => const SignIn());
    }
  });

  await FirebaseMessaging.onMessage.listen((event) {
    log(event.data.toString());
    Notificationapi.shownotification(
        event.notification!.title.toString(),
        event.notification!.body,
        jsonEncode(event.data),
        event.data['img_url'].toString());
  });

  await Hive.initFlutter();
  box1 = await Hive.openBox('logindata');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // bind our app with the  Getx Controller
      initialBinding: ControllerBindings(),
      initialRoute: Routes.INITIAL,
      getPages: AppPages.pages,
      onInit: () {
        FirebaseMessaging.instance.getToken().then((value) {
          log(value.toString());
          box1.put('device_token', value.toString());
        });

        FirebaseMessaging.instance.subscribeToTopic("All_message");
      },

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: SplashPage(),
    );
  }
}

class Notificationapi {
  static final _notificationplugin = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String>();

  static final AndroidInitializationSettings android =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  static final InitializationSettings settings = InitializationSettings(
    android: android,
  );

  static Future inint() async {
    // final details=await _notificationplugin.getNotificationAppLaunchDetails();
    // log(details!.payload.toString());
    // if(details !=null && details.didNotificationLaunchApp){
    //   onNotification.add(details.payload.toString());
// }

    await _notificationplugin.initialize(settings,
        onSelectNotification: (payload) {
      onNotification.add(payload.toString());
    });
  }

  static Future _notificationdetails(String? url) async {
    log(url.toString());

    final large = await Utlis.notificationimg(url.toString(), 'Offers');
    if (url == null) {
      return const NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          icon: "@mipmap/ic_launcher",
          priority: Priority.max,
          importance: Importance.max,
          enableVibration: true,
        ),
      );
    }
    return NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName',
          icon: "@mipmap/ic_launcher",
          priority: Priority.max,
          importance: Importance.max,
          enableVibration: true,
          styleInformation: BigPictureStyleInformation(
              FilePathAndroidBitmap(url == null ? '' : large))),
    );
  }

  static Future shownotification(String title, body, payload, url) async {
    _notificationplugin.show(
        1, '${title}', body, await _notificationdetails(url),
        payload: payload);
  }
}
