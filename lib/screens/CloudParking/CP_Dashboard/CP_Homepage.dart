import 'package:bike_cafe/widget/constrants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CloudHomepage extends StatefulWidget {
  const CloudHomepage({Key? key}) : super(key: key);

  @override
  _CloudHomepageState createState() => _CloudHomepageState();
}

class _CloudHomepageState extends State<CloudHomepage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(
            gradient: Constants.linearColor()
          ),
          child: SingleChildScrollView(

          ),
        ),
      ),
    );
  }
}
