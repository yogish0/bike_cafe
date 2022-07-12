import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bike_cafe/models/Products/check_wishlist_model.dart';
import 'package:bike_cafe/models/Products/product_review_rating_model.dart';
import 'package:bike_cafe/models/Products/products_model.dart';
import 'package:bike_cafe/screens/Dashboard/Cart/cart.dart';
import 'package:bike_cafe/screens/Dashboard/product/locale/productviewdetails.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/widget/constrants.dart';

import '../../../../models/Products/getcuponproduct.dart';

class MoreOffers extends StatefulWidget {
  const MoreOffers({Key? key, required this.token, required this.userId})
      : super(key: key);

  final String token;
  final String userId;

  @override
  _MoreOffersState createState() => _MoreOffersState();
}

class _MoreOffersState extends State<MoreOffers> {
  APIService service = APIService();

  TextWidgetStyle style = TextWidgetStyle();
  CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetCuponProductModel?>(
      future: service.getcuponprodut(token: widget.token),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: style.Roboto(
                    text: "More Offers",
                    color: Colors.black,
                    size: 16,
                    fontwight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: StaggeredGrid.count(
                  crossAxisCount: 2,
                  children: [
                    if (snapshot.data!.products!.isNotEmpty)
                      for (var i = 0; i < snapshot.data!.products!.length; i++)
                        productsList(i, snapshot)
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Center();
        }
      },
    );
  }

  Widget productsList(int index, AsyncSnapshot<GetCuponProductModel?> snapshot) {
    var products = snapshot.data!.products![index];

    int? discount = 0;

    discount = (((products.procosMrp - products.procosSellingPrice) /
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
                            size: 15),
                        style.Roboto(
                            text: " ₹ " +
                                products.procosSellingPrice.toString() +
                                "/-",
                            fontwight: FontWeight.w300,
                            color: Colors.black,
                            size: 18),
                        const Spacer(),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        side: BorderSide(color: Colors.red)))),
                            onPressed: () {
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
                      text: '$discount% Off',
                      fontwight: FontWeight.w400,
                      color: Colors.grey,
                      size: 10)),
            ),
          ],
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
