import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/controllers/bottombarcontroller.dart';
import 'package:bike_cafe/screens/Dashboard/NavBar/bottomNavBar.dart';
import 'package:bike_cafe/screens/chatbotScreen/chatbot.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/screens/Dashboard/Notification/notification.dart';
import 'package:bike_cafe/widget/constrants.dart';

class GetScaffold extends StatelessWidget {
  GetScaffold({Key? key, this.title, this.body}) : super(key: key);
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? title;
  BottomNavBarPresisitant buildBottomBar = BottomNavBarPresisitant();
  BottomNavigationController bottomcontroller = BottomNavigationController();

  dynamic? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      bottomNavigationBar:
          buildBottomBar.buildBottomBar(context, bottomcontroller),
      appBar: AppBar(
        backgroundColor: AppBarColor,
        title: Text(title.toString(),
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
        leading: IconButton(
          onPressed: () {
            Get.back(canPop: true);
          },
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
          ),
        ),
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => ChatBotPage());
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: SvgPicture.asset('assets/img/svg/Help_and_support.svg',
                      height: 24, width: 24),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => const NotificationPage());
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: SvgPicture.asset('assets/img/svg/My Notification.svg',
                      height: 24, width: 24),
                ),
              ),
            ],
          )
        ],
      ),
      body: body,

      // buildBottomBar.buildBottomBar(context, bottomcontroller)==true

      // : Get.to(),
      backgroundColor: Constants.bgcolor,
    );
  }
}
