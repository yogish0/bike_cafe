import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/screens/root.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashPage extends StatefulWidget {
//repository injection
//final MyRepository repository = MyRepository(apiClient: MyApiClient(httpClient: http.Client()));

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
      duration: const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(
        parent: _animationController!.view, curve: Curves.easeInCubic);

    _animationController!
        .forward()
        .whenComplete(() => Get.offAll(() => Root()));
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
                    width: 200,
                    height: 200,
                  ),
                ),
                // SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: style.Roboto(
                        text: "Your's Vehicle Partner",
                        fontwight: FontWeight.bold,
                        size: 22,
                        color: Colors.black)),

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
