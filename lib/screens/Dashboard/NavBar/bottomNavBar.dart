import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bike_cafe/controllers/bottombarcontroller.dart';
import 'package:bike_cafe/screens/Dashboard/Cart/cart.dart';
import 'package:bike_cafe/screens/Dashboard/Echarge/echarge.dart';
import 'package:bike_cafe/screens/Dashboard/Home/dashboard.dart';
import 'package:bike_cafe/screens/Dashboard/Search/search.dart';
import 'package:bike_cafe/screens/Dashboard/profile/profile.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:get/get.dart';

APIService service = APIService();

CartController cartController = Get.put(CartController());

BottomNavigationController bottomcontroller = BottomNavigationController();

//  _currentIndex = ;

class BottomNavBarPresisitant {
  Widget buildBottomBar(context, bottomcontroller) {
    return Container(
      color: const Color.fromRGBO(103,80,164,0.08),
      child: Row(
        children: [
          NavBarItem(
            img: "assets/img/bike_cafe_logo.png",
            index: 0,
            title: "Home",
          ),
          // NavBarItem(
          //     svgPath: "assets/img/svg/cart2.svg", index: 1, title: "Cart"),
          cartNavBarItem(index: 1),
          NavBarItem(
            img: "assets/img/echarge.png",
            index: 2,
            title: "E-Charge",
          ),
          NavBarItem(
            svgPath: "assets/img/svg/search2.svg",
            index: 3,
            title: "Search",
          ),
          NavBarItem(
            svgPath: "assets/img/svg/profile2.svg",
            index: 4,
            title: "Profile",
          ),
        ],
      ),
    );
  }

  Widget NavBarItem(
      {IconData? icon,
      var index,
      String? title,
      String? img,
      String? svgPath}) {
    return Obx(() => GestureDetector(
          onTap: () {
            // Obx(() => _currentIndex = bottomcontroller.tabIndex.value);
            // bottomcontroller.changeTabIndex;
            bottomcontroller.tabIndex.value = index;
            if (bottomcontroller.tabIndex.value == 0) {
              Get.to(() => Dashboard());
            } else if (bottomcontroller.tabIndex.value == 2) {
              Get.to(() => EchargePage());
            } else if (bottomcontroller.tabIndex.value == 3) {
              Get.to(() => SearchPage());
            } else if (bottomcontroller.tabIndex.value == 4) {
              Get.to(() => ProfilePage());
            }
            // Get.to(() => pages);

            // print(bottomcontroller.changeTabIndex);
            // print(bottomcontroller.tabIndex.value = index);

            // print("hii");
            // _currentIndex = index;
          },
          child: Container(
            height: 60,
            width: Config.Width / 5,
            decoration: index == bottomcontroller.tabIndex.value
                ? BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        kPrimaryColor.withOpacity(0.0),
                        kPrimaryColor.withOpacity(0.005)
                      ],
                    ),
                    color: index == bottomcontroller.tabIndex
                        ? Colors.grey.shade700
                        : kPrimaryColor)
                : BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                svgPath != null
                    ? SvgPicture.asset(svgPath,
                        height:
                            index == bottomcontroller.tabIndex.value ? 28 : 24,
                        width:
                            index == bottomcontroller.tabIndex.value ? 28 : 24,
                        color: index == bottomcontroller.tabIndex.value
                            ? kPrimaryColor
                            : Colors.grey.shade800)
                    : Image(
                        image: AssetImage(img!),
                        height:
                            index == bottomcontroller.tabIndex.value ? 28 : 24,
                        width:
                            index == bottomcontroller.tabIndex.value ? 28 : 24),
                Text(
                  title!,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: index == bottomcontroller.tabIndex.value
                          ? kPrimaryColor
                          : Colors.black),
                )
              ],
            ),
          ),
        ));
  }

  Widget cartNavBarItem({var index}) {
    return Obx(() => GestureDetector(
          onTap: () {
            bottomcontroller.tabIndex.value = index;
            print(bottomcontroller.tabIndex.value = index);
            Get.to(
              () => CartPage(),
            );
            // setState(() {
            //   _currentIndex = index!;
            // });
            // _currentIndex = index;
            // Obx(() => );
          },
          child: Container(
            height: 60,
            width: Config.Width / 5,
            decoration: index == bottomcontroller.tabIndex.value
                ? BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        kPrimaryColor.withOpacity(0.0),
                        kPrimaryColor.withOpacity(0.005)
                      ],
                    ),
                    color: index == bottomcontroller.tabIndex
                        ? Colors.grey.shade700
                        : kPrimaryColor)
                : BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    SvgPicture.asset("assets/img/svg/cart2.svg",
                        height:
                            index == bottomcontroller.tabIndex.value ? 28 : 24,
                        width:
                            index == bottomcontroller.tabIndex.value ? 28 : 24,
                        color: index == bottomcontroller.tabIndex.value
                            ? kPrimaryColor
                            : Colors.grey.shade800),
                    if(cartController.cartItemsCount.value != 0)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          margin: EdgeInsets.zero,
                          color: index == bottomcontroller.tabIndex
                              ? Colors.white
                              : kPrimaryColor,
                          child: Row(
                            children: [
                              const SizedBox(width: 4),
                              Text(cartController.cartItemsCount.value.toString(),
                                  style: TextStyle(
                                      fontSize:
                                          index == bottomcontroller.tabIndex.value
                                              ? 10
                                              : 8,
                                      color: index == bottomcontroller.tabIndex
                                          ? Colors.black
                                          : Colors.white)),
                              const SizedBox(width: 4),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  "Cart",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: index == bottomcontroller.tabIndex.value
                          ? kPrimaryColor
                          : Colors.black),
                )
              ],
            ),
          ),
        ));
  }

  dynamic getBody() {
    List<Widget> pages = [
      Dashboard(),
      CartPage(),
      EchargePage(),
      SearchPage(),
      ProfilePage(),
    ];
    print(bottomcontroller.tabIndex.value);
    return Obx(() => IndexedStack(
          index: bottomcontroller.tabIndex.value,
          children: pages,
        ));
  }
}
