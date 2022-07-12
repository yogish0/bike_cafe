import 'package:carousel_nullsafety/carousel_nullsafety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:bike_cafe/screens/Dashboard/OurService/Bike_Cafe/sub_category_menu_list.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/constrants.dart';
import 'package:google_fonts/google_fonts.dart';

class BikeCafe extends StatefulWidget {
  const BikeCafe({Key? key}) : super(key: key);

  @override
  _BikeCafeState createState() => _BikeCafeState();
}

class _BikeCafeState extends State<BikeCafe> {

  bool seeMoreMenu = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   foregroundColor: Colors.black,
      //   title: const Text("Bike Cafe"),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bike  Cafe",
                      style: GoogleFonts.mrDafoe(
                          fontSize: 40, fontWeight: FontWeight.bold, color: kPrimaryColor),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.location_on, color: kPrimaryColor),
                        Text("2nd stage, Nagarabhavi, Bengaluru"),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 170,
                  child: Carousel(
                    images: [
                      Image.asset("assets/bike_cafe/banner1.jpg"),
                      Image.asset("assets/bike_cafe/banner2.jpg")
                    ],
                    autoplay: true,
                    animationDuration: const Duration(seconds: 2),
                    autoplayDuration: const Duration(seconds: 5),
                    dotSize: 4,
                    dotSpacing: 15,
                    dotColor: Colors.black54,
                    dotIncreasedColor: Colors.white,
                    indicatorBgPadding: 5.0,
                    dotBgColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's menu",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    menuListWidget("assets/bike_cafe/cappuccino.jpg", "Cappuccino", "4.3", "1k+ ratings", "Hot beverage", "99"),
                    menuListWidget("assets/bike_cafe/image3.jpg", "Bike cafe special chicken burger", "4.3", "1k+ ratings", "Snacks", "99"),

                    Visibility(
                      visible: seeMoreMenu,
                      child: Column(
                        children: [
                          menuListWidget("assets/bike_cafe/pizza.jpg", "Mexican pizza", "4.2", "200+ ratings", "Snacks", "149"),
                          menuListWidget("assets/bike_cafe/pizza2.jpg", "Cheese corn pizza", "4.3", "100+ ratings", "Snacks", "179"),
                          menuListWidget("assets/bike_cafe/image2.jpg", "Chicken butter garlic", "4.1", "100+ ratings", "Snacks", "149"),
                          menuListWidget("assets/bike_cafe/cacke.jpg", "Banana cake", "4.1", "200+ ratings", "Snacks", "99"),
                          menuListWidget("assets/bike_cafe/bbq.jpg", "DBC(Death by chocolate)", "3.7", "100+ ratings", "snacks", "149"),
                          menuListWidget("assets/bike_cafe/image3.jpg", "Chicken crispy burger", "4.0", "500+ ratings", "Snacks", "139"),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !seeMoreMenu,
                      child: Center(
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              seeMoreMenu = true;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("See more"),
                              Icon(Icons.keyboard_arrow_down)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hot Beverages",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    horizontalListView([
                      categoryListWidget("assets/bike_cafe/image4.jpg","Special coffee"),
                      categoryListWidget("assets/bike_cafe/masala_tea.jpg","Special tea"),
                      categoryListWidget("assets/bike_cafe/tea.jpg","Tea without milk"),
                    ]),
                  ],
                ),

                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Cold Beverages",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    horizontalListView([
                      categoryListWidget("assets/bike_cafe/milkshake.jpg","Milk shakes"),
                      categoryListWidget("assets/bike_cafe/iced_tea.jpg","Iced tea"),
                      categoryListWidget("assets/bike_cafe/mojito.jpg","Mojito's"),
                    ]),
                  ],
                ),

                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Snacks",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    horizontalListView([
                      categoryListWidget("assets/bike_cafe/pizza.jpg","Pizza"),
                      categoryListWidget("assets/bike_cafe/pizza2.jpg","Starters"),
                      categoryListWidget("assets/bike_cafe/burger.jpg","Burger"),
                      categoryListWidget("assets/bike_cafe/pasta.jpg","Pasta"),
                      categoryListWidget("assets/bike_cafe/sandwich.jpg","Sandwich"),
                      categoryListWidget("assets/bike_cafe/nachoes.jpg","Nachos"),
                      categoryListWidget("assets/bike_cafe/Casserole.jpg","Sweet tooth"),
                      categoryListWidget("assets/bike_cafe/image2.jpg","Cookies"),
                      categoryListWidget("assets/bike_cafe/salad2.jpg","Salad"),
                      categoryListWidget("assets/bike_cafe/salad.jpg","Quick bites"),
                      categoryListWidget("assets/bike_cafe/dip.jpg","Potato twisters"),
                    ]),
                  ],
                ),

                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Desert",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    horizontalListView([
                      categoryListWidget("assets/bike_cafe/iced_tea.jpg","Ice sundae"),
                      categoryListWidget("assets/bike_cafe/chicken.jpg","Biscuit ice cream cup")
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget menuListWidget(String menuImgPath, name, rating, ratingCount, category, price) {
    return InkWell(
      onTap: (){
        Get.bottomSheet(
          bottomSheetWidget(menuImgPath, name, rating, ratingCount, category, price),
          backgroundColor: Colors.white,
        );
      },
      child: Column(
        children: [
          const SizedBox(height: 6),
          Row(
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: ClipRRect(
                  child: Image.asset(menuImgPath),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Constants.ratingCard1(rating),
                        const SizedBox(width: 4),
                        Text(ratingCount)
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(category,
                      style: const TextStyle(color: Colors.black54),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget categoryListWidget(String imgPath, subCategoryName){
    return InkWell(
      onTap: (){
        Get.to(()=> SubCategoryMenuLists(subCategoryName: subCategoryName));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(imgPath),
              ),
            ),
            const SizedBox(height: 4),
            Text(subCategoryName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Widget horizontalListView(List<Widget> subCategories){
    return SizedBox(
      height: 200,
      width: Get.width * 0.95,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for(var i=0; i< subCategories.length; i++)
            subCategories[i]
        ],
      ),
    );
  }

  Widget bottomSheetWidget(String menuImgPath, name, rating, ratingCount, category, price){
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 250,
                width: Get.width,
                child: Image.asset(menuImgPath, fit: BoxFit.cover),
              ),
              Positioned(
                right: 4,
                top: 4,
                child: InkWell(
                    onTap: (){
                      Get.back();
                    },
                  child: const Icon(Icons.close, size: 30, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Constants.ratingCard1(rating),
                    const SizedBox(width: 4),
                    Text(ratingCount)
                  ],
                ),
                const SizedBox(height: 6),
                Text(category,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.favorite_border_sharp,color: kPrimaryColor, size: 30),
                    const SizedBox(width: 20),
                    Icon(Icons.share,color: kPrimaryColor, size: 30),
                    const SizedBox(width: 20),
                    Container(
                      height: 45,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.remove, color: kPrimaryColor),
                          const SizedBox(width: 8),
                          Text("1" ,style: TextStyle(color: kPrimaryColor)),
                          const SizedBox(width: 8),
                          Icon(Icons.add, color: kPrimaryColor),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),
                    SizedBox(
                      height: 45,
                      width: Get.width * 0.45,
                      child: ElevatedButton(
                        onPressed: (){},
                        child: Text("Add item  ₹ " + price),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
