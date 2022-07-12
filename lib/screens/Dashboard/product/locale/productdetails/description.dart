import 'package:flutter/material.dart';
import 'package:bike_cafe/widget/config.dart';

class Description extends StatelessWidget {
  const Description({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextWidgetStyle style = TextWidgetStyle();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        physics: ScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: style.Roboto(
                color: Colors.black,
                size: 12,
                fontwight: FontWeight.w400,
                text:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc dignissim rhoncus viverra pulvinar scelerisque sit sagittis. Eget dapibus pretium ut accumsan sit leo egestas nisi aliquet. Nunc enim blandit sapien, sociis. Adipiscing vitae nisi, aliquet sodales. Vestibulum commodo dui viverra faucibus volutpat, leo commodo vel viverra. Consequat elit id pharetra amet non. Non, mauris nec massa suspendisse faucibus dignissim arcu risus, "),
          ),
          style.Roboto(
              color: Colors.black,
              size: 16,
              fontwight: FontWeight.w700,
              text: "Suitable Vechile"),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  style.Roboto(
                      color: Colors.black,
                      size: 16,
                      fontwight: FontWeight.w700,
                      text: "Honda"),
                  SizedBox(
                    height: 7,
                  ),
                  style.Roboto(
                      color: Colors.black,
                      size: 13,
                      fontwight: FontWeight.w400,
                      text: "Honda"),
                  SizedBox(
                    height: 7,
                  ),
                  style.Roboto(
                      color: Colors.black,
                      size: 13,
                      fontwight: FontWeight.w400,
                      text: "Honda"),
                  SizedBox(
                    height: 7,
                  ),
                  style.Roboto(
                      color: Colors.black,
                      size: 13,
                      fontwight: FontWeight.w400,
                      text: "Honda"),
                ],
              ),
              Column(
                children: [
                  style.Roboto(
                      color: Colors.black,
                      size: 16,
                      fontwight: FontWeight.w700,
                      text: "Model"),
                  SizedBox(
                    height: 7,
                  ),
                  style.Roboto(
                      color: Colors.black,
                      size: 13,
                      fontwight: FontWeight.w400,
                      text: "Honda Activa"),
                  SizedBox(
                    height: 7,
                  ),
                  style.Roboto(
                      color: Colors.black,
                      size: 13,
                      fontwight: FontWeight.w400,
                      text: "Honda CB Shine SP"),
                  SizedBox(
                    height: 7,
                  ),
                  style.Roboto(
                      color: Colors.black,
                      size: 13,
                      fontwight: FontWeight.w400,
                      text: "Honda CB Unicorn"),
                ],
              )
            ],
          ),
          SizedBox(
            height: 25,
          ),
          style.Roboto(
              color: Colors.black,
              size: 16,
              fontwight: FontWeight.w700,
              text: "Related Products"),
          //MoreOffers(token: box1!.get("data4")),
        ],
      ),
    );
  }
}
