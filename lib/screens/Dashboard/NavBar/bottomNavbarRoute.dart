// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:getx_loginpage/controllers/bottombarcontroller.dart';
// import 'package:getx_loginpage/screens/Dashboard/Cart/cart.dart';
// import 'package:getx_loginpage/screens/Dashboard/Echarge/echarge.dart';
// import 'package:getx_loginpage/screens/Dashboard/Home/dashboard.dart';
// import 'package:getx_loginpage/screens/Dashboard/NavBar/bottomNavBar.dart';
// import 'package:getx_loginpage/screens/Dashboard/NavBar/menuBar.dart';
// import 'package:getx_loginpage/screens/Dashboard/Search/search.dart';
// import 'package:getx_loginpage/screens/Dashboard/profile/profile.dart';
// import 'package:getx_loginpage/screens/SlidingScreen/RegisterVehicle.dart';
// import 'package:getx_loginpage/screens/SlidingScreen/vehicleList/listVehicle.dart';
// import 'package:getx_loginpage/services/api.dart';
// import 'package:getx_loginpage/widget/config.dart';
// import 'package:get/get.dart';
// import 'package:hive/hive.dart';

// class BottomNavBarPage extends StatefulWidget {
//   BottomNavBarPage({Key? key}) : super(key: key);

//   @override
//   State<BottomNavBarPage> createState() => _BottomNavBarPageState();
// }

// class _BottomNavBarPageState extends State<BottomNavBarPage> {
//   Box? box1;

//   @override
//   void initState() {
//     super.initState();
//     createBox();
//   }

//   void createBox() async {
//     box1 = await Hive.openBox('logindata');
//     setState(() {});
//   }

//   APIService service = APIService();

//   CartController cartController = Get.put(CartController());

//   // int _currentIndex = 0;
//   BottomNavBarPresisitant buildBottomBar = BottomNavBarPresisitant();
//   BottomNavigationController landingPageController =
//       BottomNavigationController();
//   // Get.put(BottomNavigationController(), permanent: false);

//   @override
//   Widget build(BuildContext context) {
//     return box1?.get("data4") == null
//         ? Center()
//         : Scaffold(
//             backgroundColor: kBackgroundColor,
//             bottomNavigationBar:
//                 buildBottomBar.buildBottomBar(context, landingPageController),
//             body: buildBottomBar.getBody(),
//           );

//     // body: Stack(
//     //   children: [buildBottomBar.getBody()],
//     // ));
//   }

//   //cart bottom nav widget

// }
