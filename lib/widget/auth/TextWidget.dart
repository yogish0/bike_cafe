import 'package:flutter/material.dart';
import 'package:bike_cafe/widget/config.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    Key? key,
    this.title,
    this.subtitle,
  }) : super(key: key);
  final String? title, subtitle;

  @override
  Widget build(BuildContext context) {
    TextWidgetStyle style = TextWidgetStyle();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          style.Monterserrat(
              text: title,
              color: Colors.white,
              fontwight: FontWeight.bold,
              size: 40),
          Text(subtitle.toString(),
              style: TextStyle(
                  color: kBackgroundColor,
                  fontSize: 40,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
