// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/widget/auth/TextWidget.dart';
import 'package:bike_cafe/widget/auth/vector.dart';
import 'package:bike_cafe/widget/config.dart';

class clipWidget extends StatelessWidget {
  clipWidget({Key? key, this.title, this.subtitle}) : super(key: key);
  String? title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Config.Width,
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/img/signup.png"), fit: BoxFit.fill),
      ),
      child: SafeArea(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.chevron_left_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: TextWidget(
                      title: title,
                      subtitle: subtitle,
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 120, right: 3),
                  child: Vetcor()),
            ]),
      ),
    );
  }
}
