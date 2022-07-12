import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/constrants.dart';
import 'package:google_fonts/google_fonts.dart';

class SubCategoryMenuLists extends StatelessWidget {
  const SubCategoryMenuLists({Key? key, required this.subCategoryName})
      : super(key: key);

  final String subCategoryName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Column(
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
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subCategoryName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    menuListWidget("assets/bike_cafe/cappuccino.jpg", "Cappuccino", "4.3", "1k+ ratings", "Hot beverage", "99"),
                    menuListWidget("assets/bike_cafe/image3.jpg", "Bike cafe special chicken burger", "4.3", "1k+ ratings", "Snacks", "99"),
                    menuListWidget("assets/bike_cafe/pizza.jpg", "Mexican pizza", "4.2", "200+ ratings", "Snacks", "149"),
                    menuListWidget("assets/bike_cafe/pizza2.jpg", "Cheese corn pizza", "4.3", "100+ ratings", "Snacks", "179"),
                    menuListWidget("assets/bike_cafe/image2.jpg", "Chicken butter garlic", "4.1", "100+ ratings", "Snacks", "149"),
                    menuListWidget("assets/bike_cafe/cacke.jpg", "Banana cake", "4.1", "200+ ratings", "Snacks", "99"),
                    menuListWidget("assets/bike_cafe/bbq.jpg", "DBC(Death by chocolate)", "3.7", "100+ ratings", "snacks", "149"),
                    menuListWidget("assets/bike_cafe/image3.jpg", "Chicken crispy burger", "4.0", "500+ ratings", "Snacks", "139"),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //menu widget
  Widget menuListWidget(
      String menuImgPath, name, rating, ratingCount, category, price) {
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
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                    Text(
                      category,
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
                    const Icon(Icons.favorite_border_sharp,color: kPrimaryColor, size: 30),
                    const SizedBox(width: 20),
                    const Icon(Icons.share,color: kPrimaryColor, size: 30),
                    const SizedBox(width: 20),
                    Container(
                      height: 45,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.remove, color: kPrimaryColor),
                          SizedBox(width: 8),
                          Text("1" ,style: TextStyle(color: kPrimaryColor)),
                          SizedBox(width: 8),
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