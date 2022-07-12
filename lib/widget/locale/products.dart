import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/screens/Dashboard/product/locale/productviewdetails.dart';
import 'package:bike_cafe/screens/Dashboard/wishlist/mywishlist.dart';
import 'package:bike_cafe/widget/config.dart';

class GetProduct extends StatelessWidget {
  GetProduct({Key? key, this.img, this.productname, this.price, this.newprice})
      : super(key: key);
  TextWidgetStyle style = TextWidgetStyle();
  String? img;
  String? productname;
  String? price;
  String? newprice;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Get.to(() => ProductViewDetails());
        },
        child: Card(
          margin: EdgeInsets.all(2),
          child: Container(
            width: 140,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Image.asset(img.toString()),
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    // style.Roboto(
                    //     text: "Name of the product",
                    //     color: Colors.black,
                    //     size: 10,
                    //     fontwight: FontWeight.w500,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(
                        'Name of the product',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 10,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 10,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 10,
                        ),
                        Icon(
                          Icons.star,
                          size: 10,
                          color: Colors.yellow,
                        ),
                        Icon(
                          Icons.star_border_outlined,
                          color: Colors.black,
                          size: 10,
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 8.0),
                    //   child: Row(
                    //     children: [
                    //       style.Roboto(
                    //           dec: TextDecoration.lineThrough,
                    //           text: " Rs $price/-",
                    //           fontwight: FontWeight.w900,
                    //           color: Colors.grey,
                    //           size: 12),
                    //       style.Roboto(
                    //           text: "Rs $newprice/-",
                    //           fontwight: FontWeight.w300,
                    //           color: Colors.black,
                    //           size: 14),
                    //       Spacer(),
                    //       Padding(
                    //         padding: const EdgeInsets.all(4.0),
                    //         child: InkWell(
                    //             onTap: () {},
                    //             child: Icon(
                    //               Icons.add_shopping_cart_sharp,
                    //               size: 18,
                    //             )),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            style.Roboto(
                                dec: TextDecoration.lineThrough,
                                text: "Rs $price/-",
                                fontwight: FontWeight.w400,
                                color: Colors.grey,
                                size: 10),
                            style.Roboto(
                                text: "Rs $newprice/-",
                                fontwight: FontWeight.w300,
                                color: Colors.black,
                                size: 12),
                            InkWell(
                                onTap: () {},
                                child: Icon(Icons.add_shopping_cart_sharp,
                                    size: 18))
                          ],
                        ))),
                  ],
                ),
// <<<<<<< uimodify

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
// >>>>>>> main
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
