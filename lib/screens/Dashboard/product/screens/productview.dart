import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/models/Categories/category_model.dart';
import 'package:bike_cafe/models/Products/check_wishlist_model.dart';
import 'package:bike_cafe/models/Products/products_by_cat_variant_id_model.dart';
import 'package:bike_cafe/models/Products/products_model.dart';
import 'package:bike_cafe/screens/Dashboard/Cart/cart.dart';
import 'package:bike_cafe/screens/Dashboard/product/locale/productviewdetails.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';

class ProductViewPage extends StatefulWidget {
  ProductViewPage({Key? key, required this.token, required this.userId})
      : super(key: key);

  final String token;
  final String userId;

  @override
  State<ProductViewPage> createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  APIService service = APIService();

  TextWidgetStyle style = TextWidgetStyle();

  CategoryProductsController categoryController =
      Get.put(CategoryProductsController());
  CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Config.Width * 0.2,
            child: FutureBuilder<GetCategories?>(
              future: service.getCategoriesApi(token: widget.token),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: Config.Height,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          for (var i = 0;
                              i < snapshot.data!.categories.length;
                              i++)
                            categoryLists(i, snapshot)
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          SizedBox(
            width: Config.Width * 0.8,
            child: categoryController.selectedVariantId.value == '0'
                ? FutureBuilder<GetProducts?>(
                    future: service.getProductsByCatIdApi(
                        token: widget.token,
                        categoryId: categoryController.selectedCatId.value),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              StaggeredGrid.count(
                                crossAxisCount: 2,
                                children: [
                                  if (snapshot.data!.products.isNotEmpty)
                                    for (var i = 0;
                                        i < snapshot.data!.products.length;
                                        i++)
                                      productsList(i, snapshot)
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                : FutureBuilder<GetProductsByCatAndVarientIdModel?>(
                    future: service.getProductsByCatIdVariantIdApi(
                        token: widget.token,
                        categoryId:
                            categoryController.selectedCatId.value.toString(),
                        variantId: categoryController.selectedVariantId.value
                            .toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              StaggeredGrid.count(
                                crossAxisCount: 2,
                                children: [
                                  if (snapshot.data!.products.isNotEmpty)
                                    for (var i = 0;
                                        i < snapshot.data!.products.length;
                                        i++)
                                      productsListByVariant(i, snapshot)
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget categoryLists(int index, AsyncSnapshot<GetCategories?> snapshot) {
    var category = snapshot.data!.categories[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Material(
            borderRadius: BorderRadius.circular(35),
            elevation: 4,
            child: InkWell(
              onTap: () {
                debugPrint(category.id.toString());
                categoryController.selectedCatId.value = category.id;
                setState(() {});
              },
              child: Container(
                width: categoryController.selectedCatId.value == category.id
                    ? 65
                    : 50,
                height: categoryController.selectedCatId.value == category.id
                    ? 65
                    : 50,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                      color:
                          categoryController.selectedCatId.value == category.id
                              ? Colors.red.shade500
                              : Colors.grey.shade100),
                ),
                child: Image.network(category.catImagepath.toString(),
                    height: 40, width: 40),
              ),
            ),
          ),
          const SizedBox(height: 8),
          style.Roboto(
              text: category.catName.toString(),
              textAlign: TextAlign.center,
              color: Colors.black,
              size: 10)
        ],
      ),
    );
  }

  //product list widget
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
                            height: 100,
                            width: 100,
                            child: Image.asset(
                                "assets/img/no_image_available.jpg"),
                          )
                        : Image.network(products.proImagePath.toString(),
                            height: 100,
                            width: 100, errorBuilder: (context, img, image) {
                            return Image.asset(
                                "assets/img/no_image_available.jpg",
                                height: 100,
                                width: 100);
                          }),
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
                    Icon(Icons.star, color: Colors.yellow, size: 14),
                    Icon(Icons.star, color: Colors.yellow, size: 14),
                    Icon(Icons.star, color: Colors.yellow, size: 14),
                    Icon(Icons.star, color: Colors.yellow, size: 14),
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
                            size: 13),
                        const Spacer(),
                        ElevatedButton(
                           style: ButtonStyle(
                               minimumSize: MaterialStateProperty.all(Size(25,40)),

                               shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: BorderSide(color: Colors.red),
                                    ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red)),
                            onPressed: () {
                              var addItemApi = service.addItemToCart(
                                  token: widget.token,
                                  userId: widget.userId,
                                  productId: products.productid);
                              int? success = 0;
                              addItemApi.then((value) {
                                success = value!.success;
                                // debugPrint("up $success");
                                if (success == 1) {
                                  Fluttertoast.showToast(
                                      msg: 'Item added to cart');
                                  service
                                      .cartCheckoutApi(
                                          token: widget.token,
                                          userId: widget.userId)
                                      .then((value) {
                                    if (value?.products!.length !=
                                        null) {
                                      cartController.cartItemsCount.value =
                                          value!.products!.length;
                                    }
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

  Widget productsListByVariant(
      int index, AsyncSnapshot<GetProductsByCatAndVarientIdModel?> snapshot) {
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
                            height: 100,
                            width: 100,
                            child: Image.asset(
                                "assets/img/no_image_available.jpg"),
                          )
                        : Image.network(products.proImagePath.toString(),
                            height: 100,
                            width: 100, errorBuilder: (context, img, image) {
                            return Image.asset(
                                "assets/img/no_image_available.jpg",
                                height: 100,
                                width: 100);
                          }),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.star, color: Colors.yellow, size: 14),
                    Icon(Icons.star, color: Colors.yellow, size: 14),
                    Icon(Icons.star, color: Colors.yellow, size: 14),
                    Icon(Icons.star, color: Colors.yellow, size: 14),
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
                            size: 12),
                        style.Roboto(
                            text: " ₹ " +
                                products.procosSellingPrice.toString() +
                                "/-",
                            fontwight: FontWeight.w300,
                            color: Colors.black,
                            size: 14),
                        const Spacer(),
                        ElevatedButton(
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(Size(25,40)),
                                // maximumSize: MaterialStateProperty.all(Size(40,40)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        side: BorderSide(color: Colors.red))),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red)),
                            onPressed: () {
                              var addItemApi = service.addItemToCart(
                                  token: widget.token,
                                  userId: widget.userId,
                                  productId: products.productid);
                              int? success = 0;
                              addItemApi.then((value) {
                                success = value!.success;
                                // debugPrint("up $success");
                                if (success == 1) {
                                  Fluttertoast.showToast(
                                      msg: 'Item added to cart');
                                  service
                                      .cartCheckoutApi(
                                          token: widget.token,
                                          userId: widget.userId)
                                      .then((value) {
                                    if (value?.products!.length !=
                                        null) {
                                      cartController.cartItemsCount.value =
                                          value!.products!.length;
                                    }
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
                              color: Colors.red, size: 18);
                        } else {
                          return const Icon(Icons.favorite_border,
                              color: Colors.grey, size: 18);
                        }
                      } else {
                        return const Icon(Icons.favorite_border,
                            color: Colors.grey, size: 18);
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
}

class CategoryProductsController extends GetxController {
  // selcted category Id
  var selectedCatId = 0.obs;

  //selected variant id
  var selectedVariantId = '0'.obs;
  var selectedVariantName = ''.obs;

  var vehicleTypeId = '0'.obs;
  var vehicleBrandId = '0'.obs;
  var vehicleModelId = '0'.obs;
  var vehicleVariantId = '0'.obs;
}
