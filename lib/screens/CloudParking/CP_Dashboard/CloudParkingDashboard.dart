import 'package:bike_cafe/widget/config.dart';
import 'package:flutter/material.dart';

import 'CP_Homepage.dart';

class CloudParkingDashboard extends StatefulWidget {
  const CloudParkingDashboard({Key? key}) : super(key: key);

  @override
  _CloudParkingDashboardState createState() => _CloudParkingDashboardState();
}

class _CloudParkingDashboardState extends State<CloudParkingDashboard> {
  //bottom navigation bar index
  int current_index = 0;

  //screens for bottom navigation bar
  final _screens = const [
    CloudHomepage(),
    CloudHomepage(),
    CloudHomepage(),
    // CloudHomepage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[current_index],

      //bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: const Color.fromRGBO(240, 230, 240, 1),
        //current index
        currentIndex: current_index,
        // to update current index
        onTap: (index) => setState(() {
          current_index = index;
        }),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.black54,
        selectedIconTheme: const IconThemeData(size: 26),
        selectedLabelStyle:
        const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        unselectedLabelStyle:
        const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'My Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings_outlined),
          //   label: 'Profile',
          // ),
        ],
      ),
    );
  }
}
