import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/controllers/bottombarcontroller.dart';
import 'package:bike_cafe/models/Products/products_model.dart';
import 'package:bike_cafe/screens/Dashboard/NavBar/bottomNavBar.dart';
import 'package:bike_cafe/screens/Dashboard/product/locale/productviewdetails.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/constrants.dart';
import 'package:hive/hive.dart';
import '../Cart/add_cart.dart';
import '../wishlist/add_to_wishlist.dart';

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

  AddCart addCart = AddCart();

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
              bottomNavigationBar: buildBottomBar.buildBottomBar(
                context,
                bottomcontroller,
              ),
              appBar: AppBar(
                elevation: 2,
                backgroundColor: AppBarColor,
                actions: [
                  Expanded(
                    child: Container(
                      // width: Config.Width - 40,
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.black38),
                      //     borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.all(6),
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
                          hintText: "Search",
                          hintStyle: const TextStyle(fontSize: 18),
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.search_outlined,
                              color: Colors.black38),
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
                  ),
                ],
              ),
              body: SafeArea(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // const SizedBox(height: 6),
                      Expanded(
                        // height: Get.height * 0.7,
                        // margin: const EdgeInsets.all(6),
                        child: ListView(
                          children: [
                            FutureBuilder<GetProducts?>(
                              future: service.searchProducts(
                                  token: box1?.get('data4'),
                                  searchString: searchfiled.toString()),
                              builder: (context, snapshot) {
                                log(searchController.text);
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Constants.circularWidget();
                                }
                                if (snapshot.data == null) {
                                  return Column(
                                    children: const [
                                      SizedBox(height: 50),
                                      Center(
                                        child: Text('Search for products',
                                            style: Constants.halfopacity),
                                      ),
                                    ],
                                  );
                                }
                                if (snapshot.hasData) {
                                  return snapshot.data!.products.isEmpty
                                      ? Column(
                                          children: const [
                                            SizedBox(height: 50),
                                            Center(
                                              child: Text(
                                                  'Searched product not found',
                                                  style: Constants.halfopacity),
                                            ),
                                          ],
                                        )
                                      : StaggeredGrid.count(
                                          crossAxisCount: 2,
                                          children: [
                                            if (snapshot
                                                .data!.products.isNotEmpty)
                                              for (var i = 0;
                                                  i <
                                                      snapshot.data!.products
                                                          .length;
                                                  i++)
                                                productsList(i, snapshot)
                                          ],
                                        );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
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
                            size: 14),
                        style.Roboto(
                            text: " ₹ " +
                                products.procosSellingPrice.toString() +
                                "/-",
                            fontwight: FontWeight.w300,
                            color: Colors.black,
                            size: 16),
                        const Spacer(),
                        addCart.addToCart(box1?.get('data4'),
                            box1?.get('data3'), products.productid!.toInt()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            AddWishlist(
                token: box1?.get('data4'),
                userId: box1?.get('data3'),
                productId: products.productid.toString()),
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
                    size: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
