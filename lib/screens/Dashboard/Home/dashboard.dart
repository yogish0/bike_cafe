import 'dart:io';
import 'package:carousel_nullsafety/carousel_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/controllers/bottombarcontroller.dart';
import 'package:bike_cafe/controllers/geocontroller.dart';
import 'package:bike_cafe/models/Products/get_banners.dart';
import 'package:bike_cafe/screens/Dashboard/Cart/cart.dart';
import 'package:bike_cafe/screens/Dashboard/Home/category/category.dart';
import 'package:bike_cafe/screens/Dashboard/Home/offers/moreoffer.dart';
import 'package:bike_cafe/screens/Dashboard/Home/offers/offerpage.dart';
import 'package:bike_cafe/screens/Dashboard/NavBar/bottomNavBar.dart';
import 'package:bike_cafe/screens/Dashboard/NavBar/menuBar.dart';
import 'package:bike_cafe/screens/Dashboard/Notification/notification.dart';
import 'package:bike_cafe/screens/chatbotScreen/chatbot.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/constrants.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../../main.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import '../../auth/login/signin.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  APIService service = APIService();
  CartController cartController = Get.put(CartController());
  String? token = box1.get("data4");
  String? userId = box1.get("data3");
  String location = 'Null, Press Button';
  String UserAddress = 'search';

  GeoController _controller = GeoController();

  @override
  void initState() {
    super.initState();
    service.cartCheckoutApi(token: token, userId: userId).then((value) {
      // if (value!.products == []) {
      //   cartController.cartItemsCount.value = value!.products!.length;
      //   debugPrint("cart length: "+value!.products!.length.toString());
      // }
      cartController.cartItemsCount.value = value!.products!.length;
      debugPrint("cart Updated +${value.products!.length}");
      // setState(() {});
    });
  }

  BottomNavBarPresisitant buildBottomBar = BottomNavBarPresisitant();
  BottomNavigationController bottomcontroller = BottomNavigationController();

  LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const MenuBar(),
      bottomNavigationBar:
          buildBottomBar.buildBottomBar(context, bottomcontroller),
      appBar: AppBar(
        backgroundColor: AppBarColor,
        title: Obx(
          () => Text(
            locationController.locality.toString() +
                ', ' +
                locationController.zipcode.toString(),
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => ChatBotPage());
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset('assets/img/svg/Help_and_support.svg',
                      height: 24, width: 24),
                ),
              ),
              InkWell(
                onTap: () async {
                  Get.to(() => const NotificationPage());
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset('assets/img/svg/My Notification.svg',
                      height: 24, width: 24),
                ),
              ),
            ],
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
          color: Colors.black,
        ),
      ),
      backgroundColor: Constants.bgcolor,
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text("Tap back again to close app"),
        ),
        child: DashboardList(boxData: box1),
      ),
    );
  }
}

class DeviceInfoApi {
  static final _deviceInfoPlugin = DeviceInfoPlugin();

  static Future<String> getDeviceAndroidId() async {
    String data = '';
    if (Platform.isAndroid) {
      final info = await _deviceInfoPlugin.androidInfo;
      data = "${info.androidId}";
    }
    return data;
  }
}

class DashboardList extends StatefulWidget {
  DashboardList({Key? key, this.token, this.userId, this.boxData})
      : super(key: key);
  String? token;
  String? userId;
  Box? boxData;

  @override
  _DashboardListState createState() => _DashboardListState();
}

class _DashboardListState extends State<DashboardList> {
  TextWidgetStyle style = TextWidgetStyle();

  LocationController locationController = Get.put(LocationController());

  Box? box1;
  String UserAddress = 'search';

  GeoController _controller = GeoController();

  static final _notificationplugin = FlutterLocalNotificationsPlugin();

  // final _notificationcontroller = Get.find<NotificationController>();
  String androidId = '';

  @override
  void initState() {
    super.initState();
    address();

    createBox();
    // intial();
    // Notificationapi.inint();
    // noti();

    //fetching user device id
    DeviceInfoApi.getDeviceAndroidId().then((String value) async {
      setState(() {
        androidId = value;
      });
      debugPrint("android id : " + androidId);
      await service.updateDeviceTokenApi(
          userId: box1?.get('data3'),
          deviceToken: box1?.get("device_token"),
          androidId: androidId.toString());
    });
  }

  // void noti() => Notificationapi.onNotification.stream.listen((event) {
  //       Map valueMap = event.isEmpty ? {} : json.decode(event as String);
  //
  //       if(box1?.get("data4") != null) {
  //         if (valueMap['screen'] == '1') {
  //           Get.to(() => const MyOffersPage());
  //         } else if (valueMap['screen'] == '2') {
  //           Get.to(() => const OrdersListPage());
  //         } else {
  //           Get.to(() => Dashboard());
  //         }
  //       }else{
  //         Get.to(() => const SignIn());
  //       }
  //     });
  //
  // void intial() async{
  //   FirebaseMessaging.onMessage.listen((event) {
  //     log(event.data.toString());
  //     Notificationapi.shownotification(
  //         event.notification!.title.toString(),
  //         event.notification!.body,
  //         jsonEncode(event.data),
  //         event.data['img_url'].toString());
  //   });
  // }

  void createBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {});
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    // print(placemarks);
    Placemark place = placemarks[0];
    UserAddress =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    locationController.locality.value = place.locality.toString();
    locationController.zipcode.value = place.postalCode.toString();
    // UserAddress.isEmpty
    //     ? const CircularProgressIndicator()
    //     : Get.to(GoogleMapScreen(
    //         Address: UserAddress,
    //         latitude: position.latitude,
    //         longitude: position.longitude,
    //       ));
    // isAddressadded = true;
    print(position.latitude);
    print(position.longitude);
    setState(() {});
  }

  void address() async {
    GetAddressFromLatLong;
    Position position = await _controller.getGeoLocationPosition();
    // location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    GetAddressFromLatLong(position);

    print(UserAddress);
  }

  APIService service = APIService();

  @override
  Widget build(BuildContext context) {
    return box1?.get("data4") == null
        ? const Center(child: CircularProgressIndicator(color: Colors.red))
        : RefreshIndicator(
            onRefresh: () async {
              var reload;
              setState(() {
                reload = service.getProductsApi(token: box1?.get("data4"));
              });
              return reload;
            },
            color: Colors.red,
            child: ListView(
              children: [
                const SizedBox(height: 3),
                Category(
                  token: box1?.get("data4"),
                  userId: box1?.get("data3"),
                ),
                FutureBuilder<GetBanners?>(
                  future: service.getMainPageBanners(token: box1?.get("data4")),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return bannerCarousel(snapshot);
                    } else {
                      return const Center();
                    }
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OfferPage(
                        token: box1!.get("data4"), userId: box1!.get("data3")),
                    // InkWell(
                    //   onTap: () {},
                    //   child: Align(
                    //     alignment: Alignment.bottomRight,
                    //     child: style.Roboto(text: "See All Details>>"),
                    //   ),
                    // )
                  ],
                ),

                MoreOffers(
                    token: box1!.get("data4"), userId: box1!.get("data3")),

                SizedBox(
                  height: 40,
                )
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: style.Roboto(
                //       text: "Upcoming Offers",
                //       color: Colors.black,
                //       size: 16,
                //       fontwight: FontWeight.w500),
                // ),
                // Container(
                //   margin: EdgeInsets.only(left: 6),
                //   height: 100,
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     children: [
                //       OffersCard('assets/img/oof3.png'),
                //       OffersCard('assets/img/off1.png'),
                //       OffersCard('assets/img/oof3.png'),
                //     ],
                //   ),
                // ),
              ],
            ),
          );
  }

  // Widget OffersCard(String img) {
  //   return InkWell(
  //     onTap: () {
  //       Get.to(VerifyUser());
  //     },
  //     child: Card(
  //       child: Image.asset(img),
  //     ),
  //   );
  // }

  Widget bannerCarousel(AsyncSnapshot<GetBanners?> snapshot) {
    return SizedBox(
      height: Get.height * 0.25,
      child: Carousel(
        images: [
          for (var i = 0; i < snapshot.data!.body.length; i++)
            InkWell(
              onTap: () async {
                // service
                //     .getProductsByBanners(
                //         token: box1?.get("data4"),
                //         bannerId: snapshot.data?.body[i].id.toString())
                //     .then((value) {
                //   if (value?.body.length != 0) {
                //     if (value?.body.length == 1) {
                //       Get.to(() => ProductViewDetails(
                //             token: box1?.get("data4"),
                //             productId: value?.body[0].cpProductId,
                //             productName: '',
                //           ));
                //     } else {
                //       Get.to(() => const MyOffersPage());
                //     }
                //   }
                // });
              },
              child: Image.network(
                snapshot.data!.body[i].bannerImageUrl.toString(),
                errorBuilder: (context, img, image) {
                  return Image.asset("assets/img/no_image_available.jpg",
                      height: Get.height * 0.12, width: Get.width * 0.22);
                },
              ),
            )
        ],
        autoplay: true,
        animationDuration: const Duration(seconds: 2),
        autoplayDuration: const Duration(seconds: 5),
        dotSize: 4,
        dotSpacing: 15,
        dotColor: Colors.black54,
        dotIncreasedColor: Colors.white,
        indicatorBgPadding: 5.0,
        dotBgColor: Colors.transparent,
      ),
    );
  }
}

class LocationController extends GetxController {
  var locality = ''.obs;
  var zipcode = ''.obs;
}

class Utlis {
  static Future<String> notificationimg(String url, String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/${filename}';
    final response = await http.get(Uri.parse(url));
    final file = File(path);
    await file.writeAsBytes(response.bodyBytes);
    return path;
  }
}

class Notificationapi {
  static final _notificationplugin = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String>();

  static final AndroidInitializationSettings android =
      AndroidInitializationSettings('@mipmap/ic_launcher');

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

  static Future _notificationdetails(String url) async {
    final large = await Utlis.notificationimg(url.toString(), 'Offers');
    return NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName',
          icon: "@mipmap/ic_launcher",
          priority: Priority.max,
          importance: Importance.max,
          enableVibration: true,
          styleInformation:
              BigPictureStyleInformation(FilePathAndroidBitmap(large))),
    );
  }

  static Future shownotification(String title, body, payload, url) async {
    _notificationplugin.show(
        1, '${title}', body, await _notificationdetails(url),
        payload: payload);
  }
}
