import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/controllers/bottombarcontroller.dart';
import 'package:bike_cafe/models/Products/check_wishlist_model.dart';
import 'package:bike_cafe/models/Products/products_model.dart';
import 'package:bike_cafe/screens/Dashboard/NavBar/bottomNavBar.dart';
import 'package:bike_cafe/screens/Dashboard/product/locale/productviewdetails.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:hive/hive.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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

  APIService service = APIService();
  TextWidgetStyle style = TextWidgetStyle();

  BottomNavBarPresisitant buildBottomBar = BottomNavBarPresisitant();

  BottomNavigationController bottomcontroller = BottomNavigationController();

  String searchfiled = '';
  TextEditingController searchController = TextEditingController();
  bool isSearched = false;

  @override
  Widget build(BuildContext context) {
    return box1?.get('data4') == null
        ? const Scaffold()
        : RawKeyboardListener(
            autofocus: true,
            focusNode: FocusNode(),
            onKey: (event) {
              if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                debugPrint("enter key pressed =>");
                debugPrint(searchController.text);
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: const Color.fromRGBO(236, 243, 249, 1),
              bottomNavigationBar:
                  buildBottomBar.buildBottomBar(context, bottomcontroller),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.height * 0.06,
                    ),
                    Container(
                      width: Config.Width,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.only(left: 12),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (val) {
                          log(val.toString());
                          setState(() {
                            searchfiled = val.toString();
                          });
                        },
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(fontSize: 18),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search_outlined),
                          suffixIcon: InkWell(
                            onTap: () {
                              searchController.clear();
                              isSearched == false;
                            },
                            child: const Icon(Icons.clear, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: Get.height * 0.7,
                      margin: const EdgeInsets.all(6),
                      child: ListView(children: [
                        FutureBuilder<GetProducts?>(
                          future: service.searchProducts(
                              token: box1?.get('data4'),
                              searchString: searchfiled.toString()),
                          builder: (context, snapshot) {
                            log(searchController.text);
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.data == null) {
                              return Center(
                                child: Text('No Item Found'),
                              );
                            }
                            if (snapshot.hasData) {
                              return StaggeredGrid.count(
                                crossAxisCount: 2,
                                children: [
                                  if (snapshot.data!.products.isNotEmpty)
                                    for (var i = 0;
                                        i < snapshot.data!.products.length;
                                        i++)
                                      productsList(i, snapshot)
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget productsList(int index, AsyncSnapshot<GetProducts?> snapshot) {
    var products = snapshot.data!.products[index];

    int? discount = 0;

    discount = (((products.procosMrp! - products.procosSellingPrice) /
                products.procosMrp) *
            100)
        .round();

    return InkWell(
      onTap: () {
        Get.to(() => ProductViewDetails(
            token: box1?.get('data4'),
            productId: products.productid,
            productName: products.proName.toString()));
      },
      child: Card(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              children: [
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: Center(
                    child: products.proImagePath == null
                        ? SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                                "assets/img/no_image_available.jpg"),
                          )
                        : Image.network(
                            products.proImagePath.toString(),
                            height: 100,
                            width: 100,
                            errorBuilder: (context, img, image) {
                              return Image.asset(
                                  "assets/img/no_image_available.jpg",
                                  height: 100,
                                  width: 100);
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 17),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(
                    products.proName.toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.star, color: Colors.yellow, size: 10),
                    Icon(Icons.star, color: Colors.yellow, size: 10),
                    Icon(Icons.star, color: Colors.yellow, size: 10),
                    Icon(Icons.star, color: Colors.yellow, size: 10),
                    Icon(Icons.star_border_outlined,
                        color: Colors.black, size: 10),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        style.Roboto(
                            dec: TextDecoration.lineThrough,
                            text: "₹ " + products.procosMrp.toString(),
                            fontwight: FontWeight.w400,
                            color: Colors.grey,
                            size: 10),
                        style.Roboto(
                            text: " ₹ " +
                                products.procosSellingPrice.toString() +
                                "/-",
                            fontwight: FontWeight.w300,
                            color: Colors.black,
                            size: 12),
                        const Spacer(),
                        InkWell(
                            onTap: () {
                              var addItemApi = service.addItemToCart(
                                  token: box1?.get('data4'),
                                  userId: box1?.get('data3'),
                                  productId: products.productid);
                              int? success = 0;
                              addItemApi.then((value) {
                                success = value!.success;
                                // print("up $success");
                                if (success == 1) {
                                  Fluttertoast.showToast(
                                      msg: 'Item added to cart');
                                  service
                                      .cartCheckoutApi(
                                          token: box1?.get('data4'),
                                          userId: box1?.get('data3'))
                                      .then((value) {
                                    cartController.cartItemsCount.value =
                                        value!.products!.length;
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Failed to add item to cart');
                                }
                              });
                            },
                            child: const Icon(Icons.add_shopping_cart_sharp,
                                size: 18))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    service
                        .addToWishlistApi(
                            token: box1?.get('data4'),
                            userId: box1?.get('data3'),
                            productId: products.productid.toString())
                        .then((value) {
                      setState(() {});
                    });
                  },
                  child: FutureBuilder<CheckWishlisted?>(
                    future: service.checkWishlist(
                        token: box1?.get('data4'),
                        userId: box1?.get('data3'),
                        productId: products.productid.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.checkout.iswishlist == 1) {
                          return const Icon(Icons.favorite,
                              color: Colors.red, size: 24);
                        } else {
                          return const Icon(Icons.favorite_border,
                              color: Colors.grey, size: 24);
                        }
                      } else {
                        return const Icon(Icons.favorite_border,
                            color: Colors.grey, size: 24);
                      }
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color.fromRGBO(244, 248, 236, 1),
                  ),
                  child: style.Roboto(
                      text: '$discount % Off',
                      fontwight: FontWeight.w400,
                      color: Colors.grey,
                      size: 10)),
            ),
          ],
        ),
      ),
    );
  }
}
