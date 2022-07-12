import 'package:flutter/material.dart';
import 'package:bike_cafe/widget/config.dart';

class BannerPage extends StatelessWidget {
  const BannerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Config.Height * 0.23,
      width: Config.Width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/sm-post.png"), fit: BoxFit.fill)),
    );
  }
}
