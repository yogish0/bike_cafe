import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/screens/chatbotScreen/chatbot.dart';

class Vetcor extends StatelessWidget {
  Vetcor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ChatBotPage());
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/img/Vector.png"),
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
