import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/models/Products/check_wishlist_model.dart';
import 'package:bike_cafe/models/Products/getcuponproduct.dart';
import 'package:bike_cafe/models/Products/products_model.dart';
import 'package:bike_cafe/screens/Dashboard/Cart/cart.dart';
import 'package:bike_cafe/screens/Dashboard/product/locale/productviewdetails.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';
import 'package:hive/hive.dart';

class MyOffersPage extends StatelessWidget {
  const MyOffersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      title: "My Offers",
      body: OfferPic(),
    );
  }
}

class OfferPic extends StatefulWidget {
  const OfferPic({Key? key}) : super(key: key);

  @override
  State<OfferPic> createState() => _OfferPicState();

}

class _OfferPicState extends State<OfferPic> {
  Box? box1;
  APIService service = APIService();
CartController cartController = Get.put(CartController());
  TextWidgetStyle style = TextWidgetStyle();

  @override
  void initState() {
    super.initState();
    service.getcuponprodut(token:box1?.get('data4'), );

    createBox();
  }

  void createBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {});
  }

  




  @override
  Widget build(BuildContext context) {
    return box1?.get('data4') == null
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          child:     Container(
                      height: Get.height * 0.8,
                      margin: const EdgeInsets.all(6),
                      child: ListView(children: [
                        FutureBuilder<GetCuponProductModel?>(
                          future: service.getcuponprodut(
                              token: box1?.get('data4'),
                            ),
                          builder: (context, snapshot) {
                           
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
                                  if (snapshot.data!.products!.isNotEmpty)
                                    for (var i = 0;
                                        i < snapshot.data!.products!.length;
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
            AddToWish(token: box1?.get('data4').toString(),
              userId: box1?.get('data3').toString(),productId: products.productid.toString()),
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

class AddToWish extends StatefulWidget {
  AddToWish({Key? key, this.token, this.userId, this.productId}) : super(key: key);

  String? token, userId, productId;

  @override
  _AddToWishState createState() => _AddToWishState();
}

class _AddToWishState extends State<AddToWish> {
  APIService service = APIService();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {
            service
                .addToWishlistApi(
                token: widget.token.toString(),
                userId: widget.userId.toString(),
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