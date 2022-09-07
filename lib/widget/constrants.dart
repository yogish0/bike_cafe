import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class Constants {
  var screenHeight = Get.height;
  //background color
  //light white
  static const bgcolor = Color.fromRGBO(236, 243, 249, 1);

  //white
  static const bgwhitecolor = Color.fromRGBO(255, 251, 254, 1);

  //normal half opacity text
  static const halfopacity = TextStyle(color: Colors.black54);

  //price text style red
  static const price_1 =
      TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold);

  //header texts
  static const heading1 = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const heading2 = TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.bold,
  );
  static const heading3 = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  // normal semibold texts
  static const text0 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  static const text1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const text2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const text3 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  static const text4 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  //form field color
  static const tColor = Color.fromRGBO(0, 0, 0, 0.1);

  //normal size white text
  static const greentext = TextStyle(color: Colors.green);
  static const redtext = TextStyle(color: Colors.red);

  static txtfield(String hinttext) {
    return InputDecoration(
      border: OutlineInputBorder(
        //borderSide: BorderSide(width: 2),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      hintText: hinttext,
      fillColor: Colors.white10,
    );
  }

  //Rating card

  static RatingCard(double rating) {
    return Card(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        child: Text.rich(
          TextSpan(children: [
            TextSpan(text: "$rating "),
            WidgetSpan(
              child: Icon(
                Icons.star,
                size: 14,
                color: Colors.white,
              ),
            )
          ], style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  //icon and text in one line
  static IconText({String? text, IconData? icontext, int? isWishlist}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        child: Text.rich(
          TextSpan(children: [
            WidgetSpan(
              child: Icon(icontext,
                  size: 20,
                  color: isWishlist == null ? Colors.white : Colors.red),
            ),
            TextSpan(text: " $text"),
          ], style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  static appBarOnlyTitle(String name) {
    return AppBar(
      backgroundColor: Color.fromRGBO(255, 251, 254, 1),
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
      title: Text(name),
    );
  }

  //rating card for product lists
  static ratingCard1(String? rating) {
    var avgRating = double.parse(rating!);
    var color;
    if (avgRating < 1) {
      color = const Color.fromRGBO(255, 0, 0, 1);
    }
    if (avgRating >= 1 && avgRating < 2) {
      color = const Color.fromRGBO(255, 165, 0, 1);
    }
    if (avgRating >= 2 && avgRating < 5) {
      color = const Color.fromRGBO(0, 128, 0, 1);
    }
    return Card(
      margin: EdgeInsets.zero,
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: Text.rich(
          TextSpan(children: [
            TextSpan(text: "$rating "),
            const WidgetSpan(
              child: Icon(
                Icons.star,
                size: 10,
                color: Colors.white,
              ),
            )
          ], style: const TextStyle(color: Colors.white, fontSize: 10)),
        ),
      ),
    );
  }

  static linkText(String text) {
    return Text(
      text,
      style: TextStyle(
          color: kPrimaryColor,
          fontWeight: FontWeight.w400,
          fontSize: 18,
          fontFamily: GoogleFonts.roboto().fontFamily,
          decoration: TextDecoration.underline),
    );
  }

  static cartIcon() {
    return const Card(
      color: Color.fromRGBO(230, 10, 9, 3),
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child:
            Icon(Icons.add_shopping_cart_sharp, size: 18, color: Colors.white),
      ),
    );
  }

  static circularWidget() {
    return SizedBox(
      height: Get.height - 150,
      child: const Center(
        child: CircularProgressIndicator(color: kPrimaryColor),
      ),
    );
  }

  static linearColor() => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
    colors: [
      Color.fromRGBO(255, 154, 158, 1),
      Color.fromRGBO(250, 208, 196, 1),
    ],
  );
}
