import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/models/Products/check_wishlist_model.dart';
import 'package:bike_cafe/models/Products/product_related_variants.dart';
import 'package:bike_cafe/models/Products/product_review_rating_model.dart';
import 'package:bike_cafe/models/Products/products_model.dart';
import 'package:bike_cafe/screens/Dashboard/Cart/cart.dart';
import 'package:bike_cafe/screens/Dashboard/payment/locale/checkout.dart';
import 'package:bike_cafe/screens/Dashboard/product/locale/productdetails/reviews.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';
import 'package:carousel_nullsafety/carousel_nullsafety.dart';
import 'package:hive/hive.dart';

class ProductViewDetails extends StatefulWidget {
  ProductViewDetails(
      {Key? key,
      this.children,
      required this.token,
      required this.productId,
      required this.productName})
      : super(key: key);
  var children;

  final String token;
  late int? productId;
  late String? productName;

  @override
  State<ProductViewDetails> createState() => _ProductViewDetailsState();
}

class _ProductViewDetailsState extends State<ProductViewDetails> {
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

  ProductOrderController priceController = Get.put(ProductOrderController());
  CartController cartController = Get.put(CartController());

  int mrp = 0;
  int discount = 0;
  int sellingPrice = 0;
  int tax = 0;

  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      title: widget.productName,
      body: Scaffold(
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Config.Width * 0.9,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    var addItemApi = service.addItemToCart(
                        token: widget.token,
                        userId: box1?.get("data3"),
                        productId: widget.productId);
                    // AddCartItemWidget(addItemApi);
                    int? success = 0;
                    addItemApi.then((value) {
                      success = value!.success;
                      // print("up $success");
                      if (success == 1) {
                        Fluttertoast.showToast(msg: 'Item added to cart');
                        service.cartCheckoutApi(token: widget.token, userId: box1?.get('data3')).then((value) {
                          cartController.cartItemsCount.value = value!.products!.length;
                        });
                        // Get.to(()=> CartPage());
                      } else {
                        Fluttertoast.showToast(msg: 'Failed to add item to cart');
                      }
                    });
                    // print(success);
                  },
                  child: style.Roboto(
                      text: "Add to Cart",
                      color: AppBarColor,
                      size: 14,
                      fontwight: FontWeight.w700),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                    //shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                  ),
                ),
              ),
              const SizedBox(height: 55),
            ],
          ),
        ),
        body: box1?.get("data3") == null
            ? const Center()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder<GetProducts?>(
                      future: service.getProductsByIdApi(
                          token: widget.token, productId: widget.productId.toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              for (var i = 0;i < snapshot.data!.products.length;i++)
                                productDetailsWidget(i, snapshot)
                            ],
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget productDetailsWidget(int index, AsyncSnapshot<GetProducts?> snapshot) {
    var products = snapshot.data!.products[index];
    debugPrint(products.toString());

    return Column(
      children: [
        productDetailsAndDescription(products),
        relatedVehiclesAndProducts()
      ],
    );
  }

//image Carousel
  Widget productImageCarousel(String imgUrl) {
    return Container(
      color: const Color.fromRGBO(255, 251, 254, 1),
      child: SizedBox(
        height: 250,
        child: Carousel(
          images: [
            Image.network(
              imgUrl,
              errorBuilder: (context, img, image) {
                return Image.asset("assets/img/no_image_available.jpg");
              },
            )
          ],
          autoplay: false,
          dotSize: 4,
          dotSpacing: 15,
          dotColor: Colors.black54,
          dotIncreasedColor: Colors.redAccent,
          indicatorBgPadding: 5.0,
          dotBgColor: Colors.transparent,
        ),
      ),
    );
  }

  TextWidgetStyle style = TextWidgetStyle();

  Widget productDetailsAndDescription(Product productObj) {
    int? discount = 0;

    discount = (((productObj.procosMrp! - productObj.procosSellingPrice) /
                productObj.procosMrp) * 100).round();
    return Column(
      children: [
        Stack(
          children: [
            productImageCarousel(productObj.proImagePath.toString()),
            Positioned(
              left: 6,
              top: 6,
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
                    size: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Material(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                style.Roboto(
                    text: productObj.proName.toString(),
                    size: 18,
                    fontwight: FontWeight.w400,
                    color: Colors.black),
                const SizedBox(height: 6),
                Row(
                  children: [
                    style.Roboto(
                        dec: TextDecoration.lineThrough,
                        text: "₹" + productObj.procosMrp.toString(),
                        color: Colors.grey,
                        size: 14),
                    style.Roboto(
                        text: " ₹ " + productObj.procosSellingPrice.toString() + "/-",
                        color: Colors.black,
                        size: 16),
                  ],
                ),
                const SizedBox(height: 6),

                rateWidget(productObj.productid.toString()),

                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        style.Roboto(
                            text: "SKU:",
                            size: 12,
                            fontwight: FontWeight.w400,
                            color: Colors.grey),
                        const SizedBox(height: 20),
                        style.Roboto(
                            text: "Category:",
                            size: 12,
                            fontwight: FontWeight.w400,
                            color: Colors.grey),
                        const SizedBox(height: 20),
                        style.Roboto(
                            text: "Stock:",
                            size: 12,
                            fontwight: FontWeight.w400,
                            color: Colors.grey),
                      ],
                    ),
                    Column(
                      children: [
                        style.Roboto(
                            text: productObj.proSku.toString(),
                            size: 12,
                            fontwight: FontWeight.w400,
                            color: Colors.black),
                        const SizedBox(height: 20),
                        style.Roboto(
                            text: productObj.catName.toString(),
                            size: 12,
                            fontwight: FontWeight.w400,
                            color: Colors.black),
                        const SizedBox(height: 20),
                        productObj.proIsoutofstock == 0
                            ? style.Roboto(
                                text: "In-stock",
                                size: 12,
                                fontwight: FontWeight.w400,
                                color: Colors.green)
                            : style.Roboto(
                                text: "Out-of-Stock",
                                size: 12,
                                fontwight: FontWeight.w400,
                                color: Colors.red)
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        style.Roboto(
                            text: "Buy by:",
                            size: 12,
                            fontwight: FontWeight.w400,
                            color: Colors.grey),
                        const SizedBox(height: 20),
                        style.Roboto(
                            text: "Delivery:",
                            size: 12,
                            fontwight: FontWeight.w400,
                            color: Colors.grey),
                        const SizedBox(height: 20),
                      ],
                    ),
                    Column(
                      children: [
                        style.Roboto(
                            text: productObj.packageItemsCount.toString() + ' pcs',
                            size: 12,
                            fontwight: FontWeight.w400,
                            color: Colors.black),
                        const SizedBox(height: 20),
                        style.Roboto(
                            text: "1-2 Working Days",
                            size: 12,
                            fontwight: FontWeight.w400,
                            color: Colors.black),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              style.Roboto(text: "Description", size: 18, fontwight: FontWeight.w400),
              const SizedBox(height: 10),
              style.Roboto(text: productObj.proDescription.toString(), size: 12),
            ],
          ),
        )
      ],
    );
  }

  //related vehicles list
  Widget relatedVehicles(
      int index, AsyncSnapshot<GetProductRelatedVariant?> snapshot) {
    var variants = snapshot.data!.variants[index];
    return Row(
      children: [
        style.Roboto(text: variants.vehvarName.toString(), size: 12),
        const SizedBox(width: 6),
        style.Roboto(text: variants.vehvarCc.toString(), size: 12),
      ],
    );
  }

  Widget relatedVehiclesAndProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<GetProductRelatedVariant?>(
                future: service.getProductsRelatedVehicles(
                    token: widget.token, productId: widget.productId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.variants.isEmpty) {
                      return Column();
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          style.Roboto(
                              text: "Suitable Vehicles",
                              size: 16,
                              fontwight: FontWeight.w400),
                          const SizedBox(height: 8),
                          style.Roboto(text: "Variants", size: 14),
                          const SizedBox(height: 6),
                          for (var i = 0;i < snapshot.data!.variants.length;i++)
                            relatedVehicles(i, snapshot)
                        ],
                      );
                    }
                  } else {
                    return const Center();
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        //Related Products
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              style.Roboto(
                  text: "Related Products",
                  size: 16,
                  fontwight: FontWeight.w400),
              const SizedBox(height: 8),
              relatedProductsWidget(),
              // RelatedProductsWidget(
              //   token: widget.token, userId: box1?.get("data3"),
              //   productId: widget.productId.toString(),
              // ),
              const SizedBox(height: 8),
            ],
          ),
        ),

        const SizedBox(height: 10),
        //Rating and reviews
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: style.Roboto(
                  text: "Rating and Reviews",
                  size: 16,
                  fontwight: FontWeight.w400),
            ),
            ProductReviews(token: widget.token.toString(), userId: box1?.get("data3"), productId: widget.productId.toString(), allReviews: false)
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget relatedProductsWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder<GetProducts?>(
          future: service.getRelatedProducts(
              token: widget.token, productId: widget.productId.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              int rowCount = 0;
              snapshot.data!.products.length < 6
                  ? rowCount = snapshot.data!.products.length
                  : rowCount = 6;
              return Row(
                children: [
                  if (snapshot.data!.products.isNotEmpty)
                    for (var i = 0; i < rowCount; i++)
                      relatedProductList(i, snapshot)
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

  Widget relatedProductList(int index, AsyncSnapshot<GetProducts?> snapshot) {
    var products = snapshot.data!.products[index];

    int? discount = 0;
    discount = (((products.procosMrp! - products.procosSellingPrice) /
                products.procosMrp) * 100).round();
    return InkWell(
      onTap: () {
        // Get.to(() => ProductViewDetails(
        //     token: widget.token,
        //     productId: products.productid,
        //     productName: products.proName.toString()));
        setState(() {
          widget.productId = products.productid;
          widget.productName = products.proName.toString();
        });
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
                          ? SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.asset("assets/img/no_image_available.jpg"),
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
                                  token: widget.token,
                                  userId: box1?.get("data3"),
                                  productId: products.productid);
                              int? success = 0;
                              addItemApi.then((value) {
                                success = value!.success;
                                // print("up $success");
                                if (success == 1) {
                                  Fluttertoast.showToast(msg: 'Item added to cart');
                                  service.cartCheckoutApi(token: widget.token, userId: box1?.get("data3"))
                                      .then((value) {
                                    cartController.cartItemsCount.value = value!.products!.length;
                                  });
                                } else {
                                  Fluttertoast.showToast(msg: 'Failed to add item to cart');
                                }
                              });
                            },
                            child: const Icon(Icons.add_shopping_cart_sharp, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              WishlistWidget(
                  token: widget.token,
                  userId: box1?.get("data3"),
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
      ),
    );
  }

  // rate widget
  Widget rateWidget(String? productId) {
    debugPrint(widget.productId.toString() + "  " + productId.toString());
    return FutureBuilder<GetProductReviewAndRatingModel?>(
      future: service.productRatingAndReview(
          token: widget.token.toString(),
          productId: widget.productId.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.avgRating.avgRating == null) {
            return Container();
          } else {
            return Row(
              children: [
                ratingCard(snapshot.data!.avgRating.avgRating.toString()),
                style.Roboto(
                    text: " "+snapshot.data!.totaltrating.totalrate.toString() + " reviews",
                    size: 12,
                    fontwight: FontWeight.w400,
                    color: Colors.grey),
              ],
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
  //rating card for product lists
  static ratingCard(String? rating) {
    var avgRating = double.parse(rating!);
    var color;
    if (avgRating < 1) {
      color = const Color.fromRGBO(255, 0, 0, 1);
    }
    if (avgRating >= 1 && avgRating < 2) {
      color = const Color.fromRGBO(255, 165, 0, 1);
    }
    if (avgRating >= 2 && avgRating < 5){
      color = const Color.fromRGBO(0, 128, 0, 1);
    }
    return Card(
      margin: EdgeInsets.zero,
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        child: Text.rich(
          TextSpan(children: [
            TextSpan(text: "$rating "),
            const WidgetSpan(
              child: Icon(
                Icons.star,
                size: 14,
                color: Colors.white,
              ),
            )
          ], style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ),
    );
  }
}

class WishlistWidget extends StatefulWidget {
  WishlistWidget({Key? key, this.token, this.userId, this.productId}) : super(key: key);

  String? token, userId, productId;

  @override
  _WishlistWidgetState createState() => _WishlistWidgetState();
}

class _WishlistWidgetState extends State<WishlistWidget> {
  APIService service = APIService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {
            service.addToWishlistApi(
                token: widget.token.toString(), userId: widget.userId.toString(),
                productId: widget.productId.toString())
                .then((value) {
              setState(() {});
            });
          },
          child: FutureBuilder<CheckWishlisted?>(
            future: service.checkWishlist(
                token: widget.token.toString(),
                userId: widget.userId.toString(),
                productId: widget.productId.toString()),
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
    );
  }
}

