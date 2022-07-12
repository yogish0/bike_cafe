import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/screens/root.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _animation;

  final height = Get.height;
  final width = Get.width;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _animation = CurvedAnimation(
        parent: _animationController!.view, curve: Curves.easeInCubic);

    _animationController!.forward().whenComplete(() => Get.off(() => Root()));
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextWidgetStyle style = TextWidgetStyle();

    return Scaffold(
      body: AnimatedBuilder(
        animation: _animation!,
        builder: (context, index) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.1),
                Container(
                  child: Image.asset(
                    "assets/img/bike_cafe_logo.png",
                    width: 250,
                    height: 250,
                  ),
                ),
                // SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Your's Vehicle Partner",style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                ),

                const SpinKitThreeBounce(size: 20, color: Colors.red),

                SizedBox(height: height * 0.3),
                style.Roboto(
                    text: "Designed and Developed by ",
                    fontwight: FontWeight.w300,
                    size: 12,
                    color: Colors.black),
                style.Roboto(
                    text: "Gologix Solutions Pvt Ltd",
                    fontwight: FontWeight.w300,
                    size: 12,
                    color: Colors.black)
              ],
            ),
          );
        },
      ),
    );
  }
}
