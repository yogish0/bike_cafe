import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/models/Products/check_wishlist_model.dart';
import 'package:bike_cafe/models/Products/product_review_rating_model.dart';

import 'package:bike_cafe/models/Products/products_model.dart';
import 'package:bike_cafe/screens/Dashboard/Cart/cart.dart';
import 'package:bike_cafe/screens/Dashboard/OurService/bike_car_service.dart';
import 'package:bike_cafe/screens/Dashboard/OurService/buy_sell_vehicles.dart';
import 'package:bike_cafe/screens/Dashboard/product/locale/productviewdetails.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/constrants.dart';

class OfferPage extends StatefulWidget {
  OfferPage({Key? key, required this.token, required this.userId})
      : super(key: key);

  final String token;
  final String userId;

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  APIService service = APIService();

  TextWidgetStyle style = TextWidgetStyle();
  CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetProducts?>(
      future: service.getProductsApi(token: widget.token),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: style.Roboto(
                    text: "Today's Deal",
                    color: Colors.black,
                    size: 16,
                    fontwight: FontWeight.w500),
              ),
              todayDealsWidget(snapshot),
              Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => const BikeAndCarServices());
                          },
                          child: SizedBox(
                            width: Config.Width * 0.43,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 140,
                                  width: 180,
                                  child: Image(
                                    image: AssetImage("assets/img/msc.png"),
                                    height: 80,
                                  ),
                                ),
                                style.Roboto(
                                    text: "Bike & car Services", size: 16),
                                style.Roboto(text: "Services", size: 15)
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => const BuyAndSellVehicles());
                          },
                          child: SizedBox(
                            width: Config.Width * 0.43,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 140,
                                  width: 180,
                                  child: Image(
                                    image:
                                        AssetImage("assets/img/buyAndSell.png"),
                                    height: 80,
                                  ),
                                ),
                                style.Roboto(text: "Buy & Sell", size: 16),
                                style.Roboto(text: "Vehicles", size: 15)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: const Image(
                      image: AssetImage("assets/img/off.png"),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget todayDealsWidget(AsyncSnapshot<GetProducts?> snapshot) {
    int rowCount = 0;
    snapshot.data!.products.length < 6
        ? rowCount = snapshot.data!.products.length
        : rowCount = 6;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (snapshot.data!.products.length > 0)
              for (var i = 0; i < rowCount; i++) offerProductList(i, snapshot)
          ],
        ),
      ),
    );
  }

  Widget offerProductList(int index, AsyncSnapshot<GetProducts?> snapshot) {
    var products = snapshot.data!.products[index];

    int? discount = 0;

    discount = (((products.procosMrp! - products.procosSellingPrice) /
                products.procosMrp) *
            100)
        .round();
    return InkWell(
      onTap: () {
        Get.to(() => ProductViewDetails(
            token: widget.token,
            productId: products.productid,
            productName: products.proName.toString().toUpperCase()));
      },
      child: Card(
        margin: const EdgeInsets.all(2),
        child: SizedBox(
          width: Get.width / 2.3,
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
                          ? SizedBox(
                              height: Get.height * 0.12,
                              width: Get.width * 0.22,
                              child: Image.asset(
                                  "assets/img/no_image_available.jpg"),
                            )
                          : Image.network(
                              products.proImagePath.toString(),
                              height: Get.height * 0.12,
                              width: Get.width * 0.22,
                              errorBuilder: (context, img, image) {
                                return Image.asset(
                                    "assets/img/no_image_available.jpg",
                                    height: Get.height * 0.12,
                                    width: Get.width * 0.22);
                              },
                            ),
                    ),
                  ),
                  const SizedBox(height: 17),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Text(
                      products.proName.toString().toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: const [
                  //     Icon(Icons.star, color: Colors.yellow, size: 10),
                  //     Icon(Icons.star, color: Colors.yellow, size: 10),
                  //     Icon(Icons.star, color: Colors.yellow, size: 10),
                  //     Icon(Icons.star, color: Colors.yellow, size: 10),
                  //     Icon(Icons.star_border_outlined,
                  //         color: Colors.black, size: 10),
                  //   ],
                  // ),
                  // rateWidget(products.productid.toString()),
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
                              size: 16),
                          style.Roboto(
                              text: " ₹ " +
                                  products.procosSellingPrice.toString() +
                                  "/-",
                              fontwight: FontWeight.w300,
                              color: Colors.black,
                              size: 14),
                          const Spacer(),
                          InkWell(
                            // style: ButtonStyle(
                            //     backgroundColor:
                            //         MaterialStateProperty.all(Colors.red),
                            //     shape: MaterialStateProperty.all(
                            //         RoundedRectangleBorder(
                            //             borderRadius:
                            //                 BorderRadius.circular(24.0),
                            //             side: BorderSide(color: Colors.red)))),
                            onTap: () {
                              var addItemApi = service.addItemToCart(
                                  token: widget.token,
                                  userId: widget.userId,
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
                                          token: widget.token,
                                          userId: widget.userId)
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
                            child: const Card(
                              color: Colors.red,
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(Icons.add_shopping_cart_sharp,
                                    size: 18,
                                    color: Colors.white),
                              ),
                            ),
                          ),
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
                              token: widget.token,
                              userId: widget.userId,
                              productId: products.productid.toString())
                          .then((value) {
                        setState(() {});
                      });
                    },
                    child: FutureBuilder<CheckWishlisted?>(
                      future: service.checkWishlist(
                          token: widget.token,
                          userId: widget.userId,
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
                      size: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // rate widget
  Widget rateWidget(String? productId) {
    return FutureBuilder<GetProductReviewAndRatingModel?>(
      future: service.productRatingAndReview(
          token: widget.token.toString(), productId: productId.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.avgRating.avgRating == null) {
            return const SizedBox(height: 14);
          } else {
            return Constants.ratingCard1(
                snapshot.data!.avgRating.avgRating.toString());
          }
        } else {
          return const SizedBox(height: 14);
        }
      },
    );
  }
}

class ProductListCard extends StatefulWidget {
  const ProductListCard(
      {Key? key, required this.token, required this.index, this.snapshot})
      : super(key: key);

  final String token;
  final int index;
  final AsyncSnapshot<GetProducts?>? snapshot;

  @override
  _ProductListCardState createState() => _ProductListCardState();
}

class _ProductListCardState extends State<ProductListCard> {
  @override
  Widget build(BuildContext context) {
    TextWidgetStyle style = TextWidgetStyle();
    var products = widget.snapshot!.data!.products[widget.index];

    int? discount = 0;

    discount = (((products.procosMrp! - products.procosSellingPrice) /
                products.procosMrp) *
            100)
        .round();
    return InkWell(
      onTap: () {
        Get.to(() => ProductViewDetails(
            token: widget.token,
            productId: products.productid,
            productName: products.proName.toString()));
      },
      child: Card(
        margin: const EdgeInsets.all(2),
        child: SizedBox(
          width: 160,
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
                          : Image.network(products.proImagePath.toString(),
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
                              onTap: () {},
                              child: const Icon(Icons.add_shopping_cart_sharp,
                                  size: 18))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                    size: 18,
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
      ),
    );
  }
}
