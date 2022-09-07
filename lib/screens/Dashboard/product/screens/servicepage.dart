import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/screens/Dashboard/product/screens/servicelistpage.dart';
import 'package:bike_cafe/widget/config.dart';

class ServicePage extends StatelessWidget {
  ServicePage({Key? key}) : super(key: key);
  TextWidgetStyle style = TextWidgetStyle();

  @override
  Widget build(BuildContext context) {
    return serviceWidget();
  }

  Widget getservice(final String image_location, final String image_caption) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.circular(35),
                  elevation: 2,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(color: Colors.grey.shade100),
                      image: DecorationImage(
                          image: AssetImage(image_location),
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  image_caption,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getservicelist(BuildContext context,
      {String? text, String? price, String? newprice}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Material(
          elevation: 3,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10)),
            height: 170,
            width: 300,
            child: Column(
              children: [
                style.Roboto(
                    text: "General Service",
                    color: Colors.black,
                    fontwight: FontWeight.w700,
                    size: 16),
                Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/img/ep.png"))),
                    ),
                    Container(
                      child: Column(
                        children: [Text("some details")],
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          style.Roboto(
                              text: "Rs $price/",
                              size: 12,
                              fontwight: FontWeight.w400,
                              color: Colors.black),
                          style.Roboto(
                              text: "Rs $newprice/-",
                              size: 12,
                              fontwight: FontWeight.w400,
                              color: Colors.red),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => ServiceViewPage());
                          },
                          child: style.Roboto(
                              text: "Book Now",
                              color: Colors.white,
                              size: 10,
                              fontwight: FontWeight.bold),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget serviceWidget() {
    return SizedBox(
      height: Config.Height,
      width: Config.Width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  "Coming soon...",
                  style: TextStyle(color: kPrimaryColor, fontSize: 22),
                ),
              ),
            ),
            getCategory2("assets/bike_cafe/bikewash.jpg",
                "Automatic bike wash in 2 minutes"),
            getCategory2("assets/bike_cafe/carwash.jpg", "Automatic car wash"),
            getCategory2("assets/img/msc.png", "General Services"),
            SizedBox(height: Config.screenHeight! * 0.25)
          ],
        ),
      ),
    );
  }

  Widget getCategory2(String imageLocation, String imageCaption) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: InkWell(
          onTap: () {
            // Get.to(() => ProductPage());
          },
          child: Column(
            children: [
              SizedBox(
                height: 200,
                width: Config.Width,
                child: Image.asset(imageLocation, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              Text(
                imageCaption,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
