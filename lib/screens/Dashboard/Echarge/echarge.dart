import 'package:flutter/material.dart';
import 'package:bike_cafe/controllers/bottombarcontroller.dart';
import 'package:bike_cafe/screens/Dashboard/NavBar/bottomNavBar.dart';

class EchargePage extends StatelessWidget {
  EchargePage({Key? key}) : super(key: key);
  BottomNavBarPresisitant buildBottomBar = BottomNavBarPresisitant();
  BottomNavigationController bottomcontroller = BottomNavigationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          buildBottomBar.buildBottomBar(context, bottomcontroller),
      body: Container(
        child: Center(
            child: Text(
          "Coming Soon...",
          style: TextStyle(fontSize: 30, color: Colors.red),
        )),
      ),
    );
  }
}
