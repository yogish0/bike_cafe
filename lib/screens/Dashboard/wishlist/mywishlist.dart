import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:bike_cafe/models/Products/get_wishlist_model.dart';
import 'package:bike_cafe/screens/Dashboard/Home/dashboard.dart';
import 'package:bike_cafe/screens/Dashboard/product/locale/productviewdetails.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      title: "My WishList",
      body: const Wishlist(),
    );
  }
}

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  TextWidgetStyle style = TextWidgetStyle();

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

  @override
  Widget build(BuildContext context) {
    return box1?.get("data4") == null
        ? const Center(child: CircularProgressIndicator(color: Colors.red))
        : SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(4),
              child: FutureBuilder<GetWishlistsProduct?>(
                future: service.getWishlistProducts(
                    token: box1?.get("data4"), userId: box1?.get("data3")),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.wishlist.isEmpty) {
                      return emptyList();
                    }
                    return StaggeredGrid.count(
                      crossAxisCount: Config.Width ~/ 140,
                      children: [
                        for (var i = 0; i < snapshot.data!.wishlist.length; i++)
                          productsList(i, snapshot)
                      ],
                    );
                  } else {
                    return const Center();
                  }
                },
              ),
            ),
          );
  }

  Widget emptyList() {
    return SizedBox(
      height: Config.Height * 0.9,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No products added to the wishlist"),
            TextButton(
                onPressed: () {
                  Get.to(() => Dashboard());
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.red),
                ))
          ],
        ),
      ),
    );
  }

  Widget productsList(int index, AsyncSnapshot<GetWishlistsProduct?> snapshot) {
    var products = snapshot.data!.wishlist[index];

    int? discount = 0;

    discount = (((products.procosMrp - products.procosSellingPrice) /
                products.procosMrp) * 100).round();

    return InkWell(
      onTap: () {
        Get.to(() => ProductViewDetails(
              token: box1?.get("data4"),
              productId: products.productid,
              productName: products.proName.toString(),
            ));
      },
      child: Card(
        margin: const EdgeInsets.all(2),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              children: [
                const SizedBox(height: 15),

                //image container
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: Center(
                    child: products.proImagePath == null
                        ? const SizedBox(
                            height: 100,
                            width: 100,
                            child: Icon(Icons.image_not_supported,
                                size: 50, color: Colors.black54),
                          )
                        : Image.network(products.proImagePath,
                            height: 100, width: 100),
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
                    Icon(Icons.star_border_outlined, color: Colors.black, size: 10),
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
                            text: " ₹ " + products.procosSellingPrice.toString() + "/-",
                            fontwight: FontWeight.w300,
                            color: Colors.black,
                            size: 12),
                        const Spacer(),
                        InkWell(
                            onTap: () {
                              var addItemApi = service.addItemToCart(
                                  token: box1?.get("data4"),
                                  userId: box1?.get("data3"),
                                  productId: products.productid);
                              int? success = 0;
                              addItemApi.then((value) {
                                success = value!.success;
                                // print("up $success");
                                if (success == 1) {
                                  Get.snackbar(
                                    'Product added to cart successfully',
                                    products.proName.toString(),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: const Color.fromRGBO(207, 255, 239, 1)
                                  );
                                } else {
                                  Get.snackbar(
                                    'Failed to add product to cart',
                                    products.proName.toString(),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: const Color.fromRGBO(255, 245, 235, 1)
                                  );
                                }
                              });
                            },
                            child: const Icon(Icons.add_shopping_cart_sharp, size: 18))
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
                      service.addToWishlistApi(token: box1?.get("data4"),
                          userId: box1?.get("data3"), productId: products.productid.toString())
                          .then((value) {
                        setState(() {});
                      });
                    },
                    child: const Icon(Icons.favorite, color: Colors.red, size: 24)),
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
                      text: '$discount' + '% Off',
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
