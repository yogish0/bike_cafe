import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/models/UserProfile/userprofile.dart';
import 'package:bike_cafe/screens/Dashboard/profile/locale/editprofile.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomerDetails extends StatefulWidget {
  CustomerDetails({Key? key, this.details}) : super(key: key);
  List? details;

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  Box? box1;
  @override
  void initState() {
    super.initState();

    createBox();
  }

  void createBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextWidgetStyle style = TextWidgetStyle();

    return Container(
      height: Config.Height,
      child: ListView(
        children: [
          Container(
            child: Stack(
              children: [
                Card(
                  margin: EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        //profile photo
                        ClipOval(
                          child: Container(
                              child: Image.asset('assets/img/go-logo4.png',
                                  width: 120, height: 120)),
                        ),

                        SizedBox(height: 5),
                        //profile name
                        Container(
                          child: TextWidget(text: "${box1!.get('data0')}"),
                        ),

                        SizedBox(height: 5),
                        //profile email
                        Container(
                          child: TextWidget(text: "${box1!.get('data2')}"),
                        ),

                        SizedBox(height: 5),
                        //profile name
                        Container(
                          child: TextWidget(text: "${box1!.get('data1')}"),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                //edit button
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    child: IconButton(
                        onPressed: () {
                          Get.to(EditProfile());
                        },
                        icon: Icon(Icons.edit)),
                  ),
                ),

                //wallet card
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    child: Row(
                      children: [
                        Text(
                          'Wallet ',
                          // style: Constants.profiletext3,
                        ),
                        Icon(
                          Icons.account_balance_wallet,
                          size: 14,
                        ),
                        Card(
                          child: Text(
                            ' ' + '100' + ' GC ',
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          ProfilebBio(
              icon: Icons.shopping_cart, title: "My Cart", onpressed: () {}),
          SizedBox(
            height: 8,
          ),
          ProfilebBio(
              icon: Icons.file_present_rounded,
              title: "My Orders",
              onpressed: () {}),
          SizedBox(
            height: 8,
          ),
          ProfilebBio(
              icon: Icons.apartment_rounded,
              title: "My Address",
              onpressed: () {}),
          SizedBox(
            height: 8,
          ),
          ProfilebBio(
              icon: Icons.favorite, title: "My Wishlist", onpressed: () {}),
          SizedBox(
            height: 8,
          ),
          ProfilebBio(
              icon: Icons.person, title: "My Profile", onpressed: () {}),
          SizedBox(
            height: 8,
          ),
          ProfilebBio(
              icon: Icons.notifications,
              title: "My Notifications",
              onpressed: () {}),
          SizedBox(
            height: 8,
          ),
          ProfilebBio(icon: Icons.chat, title: "My Chats", onpressed: () {}),
          SizedBox(
            height: 8,
          ),
          ProfilebBio(
              icon: Icons.wallet_giftcard,
              title: "My Offers",
              onpressed: () {}),
          SizedBox(
            height: 8,
          ),
          Material(
            elevation: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          // size: 20,
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Wallet",
                            ),
                            Text(
                              "GC : Golo Coin, 1GC = ₹ 1",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: style.Roboto(
                        text: "0.0",
                        color: Colors.green,
                        fontwight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          ProfilebBio(
              icon: Icons.upcoming, title: "Comming Soon", onpressed: () {}),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget TextWidget({String? text}) {
    return Text(
      text!,
      style: TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800),
    );
  }

  Widget ProfilebBio({String? title, IconData? icon, onpressed}) {
    return Expanded(
      child: Container(
        color: Colors.red,
        height: 40,
        child: Material(
          elevation: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Container(
                  width: 159,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: Colors.black,
                      ),
                      SizedBox(width: 12),
                      Text(title!),
                    ],
                  ),
                ),
              ),
              TextButton(
                  onPressed: onpressed,
                  child: Text(
                    "View",
                    style: TextStyle(color: kPrimaryColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
