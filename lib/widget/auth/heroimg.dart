import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bike_cafe/widget/config.dart';

class HeroImage extends StatelessWidget {
  const HeroImage({
    Key? key,
    @required this.path,
    @required this.sementicLabel,
  }) : super(key: key);

  final String? path, sementicLabel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: SvgPicture.asset(
        path!,
        semanticsLabel: sementicLabel,
      ),
    );
  }
}
