import 'package:flutter/material.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';

class ServiceViewPage extends StatelessWidget {
  ServiceViewPage({Key? key}) : super(key: key);
  TextWidgetStyle style = TextWidgetStyle();

  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      index: 6,
      title: "Service",
      body: service(),
    );
  }

  Widget service() {
    return Column(
      children: [
        Container(
          height: Config.Height * 0.3,
          width: Config.Width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/img/msc.png"), fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: style.Roboto(
                  text: "Rs 399",
                  color: Colors.white,
                  size: 20,
                  fontwight: FontWeight.w600),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: Config.Height * 0.4,
            width: Config.Width,
            child: ListView(
              children: [
                style.Roboto(
                    text: "Feature",
                    color: Colors.black,
                    size: 20,
                    fontwight: FontWeight.w600),
                SizedBox(
                  height: 20,
                ),
                Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: style.Roboto(
              text: "Quick Booking",
              color: Colors.white,
              size: 16,
              fontwight: FontWeight.w500),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(kPrimaryColor)),

          //  Text("Quick Booking")
        )
      ],
    );
  }
}
