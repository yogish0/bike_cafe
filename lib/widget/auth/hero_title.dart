import 'package:flutter/material.dart';
import 'package:bike_cafe/widget/config.dart';

class HeroTitle extends StatelessWidget {
  const HeroTitle({
    Key? key,
    @required this.title,
    @required this.subtitle,
  }) : super(key: key);

  final String? title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title!,
            style: TextStyle(
              fontSize: Config.Width * 0.1,
              // fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: Config.Width * 0.045,
            ),
          ),
          SizedBox(height: Config.Height * 0.005),
        ],
      ),
    );
  }
}
