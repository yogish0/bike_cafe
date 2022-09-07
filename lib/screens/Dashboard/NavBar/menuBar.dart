import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/models/auth/logout_model.dart';
import 'package:bike_cafe/screens/Dashboard/Address/locale/addresspage.dart';
import 'package:bike_cafe/screens/Dashboard/Cart/cart.dart';
import 'package:bike_cafe/screens/Dashboard/Home/category/categorypage.dart';
import 'package:bike_cafe/screens/Dashboard/MyOrder/orders_list.dart';
import 'package:bike_cafe/screens/Dashboard/Notification/notification.dart';
import 'package:bike_cafe/screens/Dashboard/OurService/Bike_Cafe/bike_cafe.dart';
import 'package:bike_cafe/screens/Dashboard/myoffres/myoffers.dart';
import 'package:bike_cafe/screens/Dashboard/profile/profile.dart';
import 'package:bike_cafe/screens/Dashboard/wishlist/mywishlist.dart';
import 'package:bike_cafe/screens/SlidingScreen/vehicleList/listVehicle.dart';
import 'package:bike_cafe/screens/auth/login/signin.dart';
import 'package:bike_cafe/screens/chatbotScreen/chatbot.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../auth/sign_up/google_authentication.dart';

class MenuBar extends StatefulWidget {
  const MenuBar({Key? key}) : super(key: key);

  @override
  State<MenuBar> createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  LogoutModel? logout;

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

  GoogleAuthentication googleAuthentication = GoogleAuthentication();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        child: ListView(
          children: [
            buildmenuItemWithAssets(
              img: "assets/img/svg/all_categories.svg",
              text: "All Categories",
              ontap: () {
                Get.to(() => const CategoryPage());
              },
            ),
            buildmenuItemWithAssets(
                img: "assets/img/svg/Bike Cafe.svg",
                text: "Bike Cafe",
                ontap: () {
                  Get.to(() => const BikeCafe());
                }),
            const Divider(color: Colors.black),
            buildmenuItemWithAssets(
                img: "assets/img/svg/My Vehicles.svg",
                text: "My Vehicles",
                ontap: () {
                  Get.to(() => ListedVehicle());
                }),
            buildmenuItemWithAssets(
                img: "assets/img/svg/My cart.svg",
                text: "My Cart",
                ontap: () {
                  Get.to(() => const CartPage());
                }),
            buildmenuItemWithAssets(
                img: "assets/img/svg/My orders.svg",
                text: "My Orders",
                ontap: () {
                  Get.to(() => const OrdersListPage());
                }),
            buildmenuItemWithAssets(
                img: "assets/img/svg/My Addresss.svg",
                text: "My Address",
                ontap: () {
                  Get.to(() => AddressPageList(routeName: '/mydashboard'));
                }),
            buildmenuItemWithAssets(
                img: "assets/img/svg/My Wishlist.svg",
                text: "My Wishlist",
                ontap: () {
                  Get.to(() => const WishList());
                }),
            buildmenuItemWithAssets(
                img: "assets/img/svg/My profile.svg",
                text: "My Profile",
                ontap: () {
                  Get.to(() => const ProfilePage());
                }),
            buildmenuItemWithAssets(
                img: "assets/img/svg/My Notification.svg",
                text: "My Notifications",
                ontap: () {
                  Get.to(() => const NotificationPage());
                }),
            buildmenuItemWithAssets(
                img: "assets/img/svg/offers.svg",
                text: "My Offers",
                ontap: () {
                  Get.to(() => const MyOffersPage());
                }),
            const Divider(color: Colors.black),
            // buildmenuItemWithAssets(icon: Icons.settings, text: "Settings"),
            buildmenuItemWithAssets(
                img: "assets/img/svg/Help_and_support.svg",
                text: "Help & Support",
                ontap: () {
                  Get.to(() => ChatBotPage());
                }),
            buildmenuItemWithAssets(
                img: "assets/img/svg/log out.svg",
                text: "LogOut",
                ontap: () {
                  if (box1!.get("isGoogleAuth") != null) {
                    if (box1!.get("isGoogleAuth") == true) {
                      googleAuthentication.logOut();
                      box1!.put("isGoogleAuth", false);
                    }
                  }
                  APIService apiService = APIService();
                  var token = box1!.get("data4");
                  if (token != null) {
                    apiService.logout(responsemodel: logout, token: token);
                    box1!.put('isLogged', false);
                    Get.offAll(() => const SignIn());
                  } else {
                    debugPrint("failed to logout");
                  }
                }),
            const Divider(color: Colors.black),
            TextButton(
                onPressed: () async {
                  if (!await launchUrl(
                      Uri.parse("https://bikecafe.co.in/privacyandpolicy/")))
                    throw 'Could not launch _url';
                },
                child: const Text("Privacy and policy")),
            // TextButton(onPressed: () {}, child: const Text("Refer and Earn")),
            TextButton(onPressed: () {}, child: const Text("Legal")),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Follow us On",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 50,
                  child: SignInButton.mini(
                      buttonType: ButtonType.facebook,
                      buttonSize: ButtonSize.small,
                      onPressed: () async {
                        if (!await launchUrl(Uri.parse(
                            "https://www.facebook.com/ilovebikecafe/")))
                          throw 'Could not launch _url';
                      }),
                ),
                SizedBox(
                  width: 50,
                  child: SignInButton.mini(
                      buttonType: ButtonType.twitter,
                      onPressed: () async {
                        if (!await launchUrl(
                            Uri.parse("https://twitter.com/Gologixpvtltd")))
                          throw 'Could not launch _url';
                      },
                      buttonSize: ButtonSize.small),
                ),
                SizedBox(
                  width: 50,
                  child: SignInButton.mini(
                      buttonType: ButtonType.instagram,
                      onPressed: () async {
                        if (!await launchUrl(
                            Uri.parse("https://instagram.com/ilovebikcafe/")))
                          throw 'Could not launch _url';
                      },
                      buttonSize: ButtonSize.small),
                ),
                SizedBox(
                  width: 50,
                  child: SignInButton.mini(
                      buttonType: ButtonType.linkedin,
                      onPressed: () async {
                        if (!await launchUrl(Uri.parse(
                            "https://www.linkedin.com/company/gologixpvtltd/")))
                          throw 'Could not launch _url';

                        // Get.to("https://www.instagram.com/ilovebikcafe/");
                      },
                      buttonSize: ButtonSize.small),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({String? text, IconData? icon, final ontap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey.shade800.withOpacity(0.75),
      ),
      title: Text(
        text!,
        style: const TextStyle(color: Colors.black),
      ),
      hoverColor: Colors.redAccent[400],
      onTap: ontap,
    );
  }

  Widget buildmenuItemWithAssets({String? text, String? img, final ontap}) {
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 25,
              height: 25,
              child: SvgPicture.asset(img.toString()),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, top: 4),
              child: Text(
                text!,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
