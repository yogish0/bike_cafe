import 'package:flutter/material.dart';
import 'package:bike_cafe/screens/auth/login/signin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

const kPrimaryColor = Color.fromRGBO(230, 10, 9, 3);
const kBackgroundColor = Color(0xFFFFFFFF);
const kErrorColor = Color(0xFFFE5350);
const containerColor = Color.fromRGBO(0, 0, 0, 0.1);
const AppBarColor = Color.fromRGBO(255, 251, 254, 1);

class Config {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static Orientation? orientation;

  static final Height = Get.height;
  static final Width = Get.width;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
  }
}

class TextWidgetStyle {
  Widget Monterserrat({String? text, var color, double? size, var fontwight}) {
    return Text(
      text!,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: fontwight,
          fontFamily: GoogleFonts.montserrat().fontFamily),
    );
  }

  Widget OpenSans({String? text, var color, double? size, var fontwight}) {
    return Text(
      text!,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: fontwight,
          fontFamily: GoogleFonts.openSans().fontFamily),
    );
  }

  Widget Roboto(
      {String? text, var color, double? size, var fontwight, var dec, TextAlign? textAlign, int? maxLine, TextOverflow? overflow}) {
    return Text(
      text!,
      textAlign: textAlign,
      maxLines: maxLine,
      overflow: overflow,
      style: TextStyle(
          color: color,
          fontSize: size,
          decoration: dec,
          decorationColor: Colors.red,
          fontWeight: fontwight,
          fontFamily: GoogleFonts.roboto().fontFamily),
    );
  }
}
