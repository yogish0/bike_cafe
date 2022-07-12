import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bike_cafe/widget/config.dart';

class TabbarPage extends StatelessWidget {
  TabbarPage({Key? key, this.children}) : super(key: key);
  var children;

  @override
  Widget build(BuildContext context) {
    TextWidgetStyle style = TextWidgetStyle();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Material(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: Config.Width,
                height: 40,
                child: TabBar(
                  indicatorColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  automaticIndicatorColorAdjustment: true,
                  labelColor: Colors.white,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: kPrimaryColor),
                  tabs: [
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          // color: Color.fromRGBO(184, 179, 179, 1),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: style.Roboto(text: "Auto-motive parts"),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: style.Roboto(
                            text: "Services",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            // color: Colors.red,
            height: Config.Height * 0.5,
            child: TabBarView(children: children),
          ),
        ],
      ),
    );
  }
}
