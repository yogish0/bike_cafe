import 'package:flutter/material.dart';
import 'package:bike_cafe/widget/auth/TextWidget.dart';
import 'package:bike_cafe/widget/auth/vector.dart';

class ClipPathWidget extends StatelessWidget {
  const ClipPathWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 370,
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                alignment: Alignment.bottomRight,
                image: AssetImage("assets/img/Ellipse21.png"),
                fit: BoxFit.fitHeight)),
        height: 200,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 70.0),
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/img/Ellipse1.png"),
                    fit: BoxFit.cover)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      "assets/img/shape.png",
                      width: 200,
                      height: 90,
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(15.0), child: Vetcor()),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15),
                child: TextWidget(
                  title: "Welcome",
                  subtitle: "Back",
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
