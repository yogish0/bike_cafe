import 'package:bike_cafe/controllers/bottombarcontroller.dart';
import 'package:bike_cafe/models/Cart_Model/cart_checkout_model.dart';
import 'package:bike_cafe/models/Products/check_wishlist_model.dart';
import 'package:bike_cafe/models/Storage/address/getaddressmodel.dart';
import 'package:bike_cafe/screens/Dashboard/Address/locale/addresspage.dart';
import 'package:bike_cafe/screens/Dashboard/Home/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bike_cafe/screens/Dashboard/NavBar/bottomNavBar.dart';
import 'package:bike_cafe/screens/Dashboard/payment/mainpage.dart';
import 'package:bike_cafe/screens/Dashboard/product/locale/productviewdetails.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/constrants.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';
import 'package:hive/hive.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Box? box1;

  @override
  void initState() {
    super.initState();
    createBox().then((value){
      service.cartCheckoutApi(token: box1!.get("data4"), userId: box1!.get("data3")).then((value) {
        if (value?.success == "1") {
          cartController.cartItemsCount.value = value!.products!.length;
        }
      });
    });
  }

  Future<void> createBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {});
  }

  CartController cartController = Get.put(CartController());
  int cartCounts = 0;
  BottomNavBarPresisitant buildBottomBar = BottomNavBarPresisitant();
  BottomNavigationController bottomcontroller = BottomNavigationController();

  @override
  Widget build(BuildContext context) {
    APIService service = APIService();

    return GetScaffold(
      title: "My cart",
      body: Column(
        children: [
          box1?.get("data4") == null
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.red))
              : Expanded(
                  // height: height * 0.73,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),

                        //Deliver address
                        FutureBuilder<GetAddressResponseModel?>(
                          future: service.addressdata(
                              id: box1?.get("data3"),
                              token: box1?.get("data4")),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.addresses.length == 0) {
                                return noAddressWidget();
                              } else {
                                return Column(
                                  children: [
                                    for (var i = 0; i < snapshot.data!.addresses.length;i++)
                                      deliveryAddress(i, snapshot)
                                  ],
                                );
                              }
                            } else {
                              return const Center();
                            }
                          },
                        ),
                        const SizedBox(height: 10),

                        // cart checkout details details
                        CartDesign(token: box1?.get("data4"),
                            userId: box1?.get("data3"))
                      ],
                    ),
                  ),
                ),
          SizedBox(
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //   padding: EdgeInsets.all(8),
                //   height: 65,
                //   width: Config.Width * 0.40,
                //   child: Column(
                //     //crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text('Subtotal'),
                //       SizedBox(height: 5),
                //       Text(cartController.totalCartPrice.value.toString(), style: Constants.price_1),
                //     ],
                //   ),
                // ),

                SizedBox(
                  width: Config.Width * 0.9,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      var address = service.addressdata(
                          id: box1?.get("data3"), token: box1?.get("data4"));
                      var addresscount = 0;
                      address.then((value) {
                        addresscount = value!.addresses.length;
                        if (addresscount != 0) {
                          var cartList = service.cartCheckoutApi(
                              token: box1?.get("data4"),
                              userId: box1?.get("data3"));
                          var cartItemCount = 0;
                          cartList.then((value) {
                            cartItemCount = value!.products!.length;
                            if (cartItemCount != 0) {
                              Get.to(() => const MainPage());
                              // Get.to(() => const CheckoutPage());
                            } else {
                              Get.snackbar('No items found in cart',
                                  'Add items to cart',
                                  duration: const Duration(seconds: 3),
                                  backgroundColor:
                                      const Color.fromRGBO(0, 0, 0, 0.8),
                                  colorText: Colors.white);
                            }
                          });
                        } else {
                          Get.snackbar('No address Found',
                              'Add address to place order',
                              backgroundColor:
                                  const Color.fromRGBO(0, 0, 0, 0.8),
                              colorText: Colors.white);
                        }
                      });
                    },
                    child: style.Roboto(
                        text: "Place Order",
                        color: AppBarColor,
                        size: 14,
                        fontwight: FontWeight.w700),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(kPrimaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  APIService service = APIService();
  TextWidgetStyle style = TextWidgetStyle();

  //delivery address widget
  Widget deliveryAddress(
      int index, AsyncSnapshot<GetAddressResponseModel?> snapshot) {
    var address = snapshot.data!.addresses[index];

    return address.addIsDefault == 0
        ? const Center()
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            color: const Color.fromRGBO(255, 251, 254, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Config.Width * 0.74,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Deliver to  '),
                          SizedBox(
                            width: Config.Width * 0.35,
                            child: Text(
                              address.name.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            ',' + address.addPincode.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        address.addAddress.toString() +
                            ', ' +
                            address.addDescription.toString() +
                            ' ,' +
                            address.cityName.toString() +
                            ' ,' +
                            address.stateName.toString(),
                        style: Constants.halfopacity,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: Config.Width * 0.2,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => AddressPageList(routeName: '/mycart'));
                    },
                    child: style.Roboto(
                        text: "Change",
                        color: AppBarColor,
                        size: 12,
                        fontwight: FontWeight.w700),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  //no address widget
  Widget noAddressWidget() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("No address added yet."),
          TextButton(
            onPressed: () {
              Get.to(() => AddressPageList(routeName: '/mycart'));
            },
            child: const Text("Add Address",
                style: TextStyle(color: kPrimaryColor)),
            // style: ButtonStyle(
            //   foregroundColor: MaterialStateProperty.all(kPrimaryColor),
            // ),
          ),
        ],
      ),
    );
  }
}

class CartDesign extends StatefulWidget {
  CartDesign({Key? key, this.token, this.userId}) : super(key: key);

  String? token, userId;

  @override
  _CartDesignState createState() => _CartDesignState();
}

class _CartDesignState extends State<CartDesign> {
  APIService service = APIService();
  TextWidgetStyle style = TextWidgetStyle();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CartCheckoutModel?>(
      future: service.cartCheckoutApi(
          token: widget.token.toString(),
          userId: widget.userId.toString(),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var totalCartItems = snapshot.data!.products!.length;
          if (totalCartItems == 0) {
            return emptyCart();
          } else {
            return Column(
              children: [
                for (var i = 0; i < snapshot.data!.products!.length;i++)
                  cartLists(i, snapshot),
                const SizedBox(height: 10),
                priceDetailsWidget(snapshot,snapshot.data!.products!.length)
              ],
            );
          }
        } else {
          return const Center();
        }
      },
    );
  }

  Widget emptyCart() {
    return Container(
      height: 500,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Your Cart is Empty'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    Get.to(() => Dashboard());
                  },
                  child: const Text('Continue Shopping')),
              const Text('to Add Products to Cart')
            ],
          )
        ],
      ),
    );
  }

  //Cart List
  Widget cartLists(int index, AsyncSnapshot<CartCheckoutModel?> snapshot) {
    var products = snapshot.data!.products![index];

    return SizedBox(
      width: Config.Width,
      child: Card(
        child: Row(
          children: [
            //image
            Container(
              width: Config.Width * 0.35,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Image.network(
                      products.proImagePath.toString(),
                    ),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                    ),
                    child: FutureBuilder<CheckWishlisted?>(
                      future: service.checkWishlist(
                          token: widget.token.toString(),
                          userId: widget.userId.toString(),
                          productId: products.productid.toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.checkout.iswishlist == 1) {
                            return Constants.IconText(
                                text: 'wishlist',
                                icontext: Icons.favorite_sharp,
                                isWishlist: 1);
                          } else {
                            return Constants.IconText(
                                text: 'wishlist',
                                icontext: Icons.favorite_outline);
                          }
                        } else {
                          return Constants.IconText(
                              text: 'wishlist',
                              icontext: Icons.favorite_outline);
                        }
                      },
                    ),
                    onPressed: () {
                      service
                          .addToWishlistApi(
                          token: widget.token.toString(),
                          userId: widget.userId.toString(),
                          productId: products.productname.toString())
                          .then((value) {
                        setState(() {});
                      });
                    },
                  ),
                  const SizedBox(height: 5),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                    ),

                    child: Constants.IconText(
                        text: 'Remove', icontext: Icons.close),
                    onPressed: () {
                      debugPrint('Removed');
                      Get.defaultDialog(
                        content: Text('Do yoy want to remove ' +
                            products.productname.toString() +
                            ' from cart'),
                        radius: 5,
                        onCancel: () {},
                        onConfirm: () {
                          var remove = service.removeCartItem(
                              token: widget.token.toString(),
                              userId: widget.userId.toString(),
                              productId: products.productid.toString());
                          remove.then((value) {
                            service
                                .cartCheckoutApi(
                              token: widget.token.toString(),
                              userId: widget.userId.toString(),)
                                .then((value) {
                              cartController.cartItemsCount.value =
                                  value!.products!.length;
                              debugPrint('length is data'+value.products!.length.toString());
                            });
                            setState(() {});
                            Get.back();
                          });
                        },
                        textConfirm: 'Confirm',
                        buttonColor: kPrimaryColor,
                        cancelTextColor: kPrimaryColor,
                        confirmTextColor: Colors.white,
                      );
                    },
                  )
                ],
              ),
            ),

            //details
            Container(
              width: Config.Width * 0.55,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => ProductViewDetails(
                          token: widget.token.toString(),
                          productId: products.productid,
                          productName: products.productname.toString()));
                    },
                    child: Text(
                      products.productname.toString().toUpperCase(),
                      style: Constants.text0,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  //category text
                  Row(
                    children: [
                      const Text('Category : ', style: Constants.halfopacity),
                      Text(products.catName.toString(),
                          style: Constants.halfopacity),
                      //products.catName.toString()
                    ],
                  ),
                  const SizedBox(height: 5),

                  //rating
                  // Constants.RatingCard(4.3),

                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.yellow, size: 14),
                      Icon(Icons.star, color: Colors.yellow, size: 14),
                      Icon(Icons.star, color: Colors.yellow, size: 14),
                      Icon(Icons.star, color: Colors.yellow, size: 14),
                      Icon(Icons.star_border_outlined,
                          color: Colors.black, size: 14),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          style.Roboto(
                              dec: TextDecoration.lineThrough,
                              text: "₹" + products.procosMrp.toString(),
                              color: Colors.grey,
                              size: 14),
                          style.Roboto(
                              text: " ₹ " +
                                  products.procosSellingPrice.toString() +
                                  "/-",
                              color: Colors.black,
                              size: 16),
                        ],
                      ),
                      const Spacer(),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                                child: InkWell(
                                  child: const Icon(
                                    Icons.remove,
                                    size: 24,
                                  ),
                                  onTap: () {
                                    if (products.cartQuantity > 1) {
                                      var decrement =
                                      service.decrementCartItemCount(
                                          token: widget.token.toString(),
                                          userId: widget.userId.toString(),
                                          productId: products.productid.toString());
                                      decrement.then((value) {
                                        setState(() {});
                                      });
                                    }
                                  },
                                ),
                              ),
                              Text(
                                ' ' + products.cartQuantity.toString() + ' ',style: TextStyle(fontSize: 18),),
                              //in 1 place, we need to pass total count
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                                child: InkWell(
                                  child: const Icon(
                                    Icons.add,
                                    size: 24,
                                  ),
                                  onTap: () {
                                    var increment = service.addItemToCart(
                                        token: widget.token.toString(),
                                        userId: widget.userId.toString(),
                                        productId: products.productid);
                                    increment.then((value) {
                                      setState(() {});
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Price Details widget

  Widget priceDetailsWidget(
      AsyncSnapshot<CartCheckoutModel?> snapshot, int totalItems) {
    var checkout = snapshot.data!;

    var bagTotal = checkout.grandTotal == null
        ? 0
        : checkout.grandTotal.toStringAsFixed(2);
    var totalMrp = checkout.grandTotal == null
        ? 0
        : checkout.totalMrp.toStringAsFixed(2);
    var saving = checkout.savings == null
        ? 0
        : checkout.savings.toStringAsFixed(2);
    var totalTax = checkout.totalTax == null
        ? 0
        : (checkout.totalTax).toStringAsFixed(2);
    var cgst =
    checkout.cgst == null ? 0 : (checkout.cgst).toStringAsFixed(2);
    var sgst =
    checkout.sgst == null ? 0 : (checkout.sgst).toStringAsFixed(2);
    var deliveryCharge = checkout.deliverycharges == null ? 0 : (checkout.deliverycharges).toStringAsFixed(2);

    // cartController.totalCartPrice.value = bagTotal!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: Constants.bgwhitecolor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PRICE DETAILS', style: Constants.halfopacity),
          const Divider(),

          //3 will be total cart item count and price will be total normal price of cart items
          oldPriceRow(
              'Price ( ' + totalItems.toString() + ' items)', '₹ $totalMrp'),

          priceRow('Discount', '- ₹ $saving'),

          // priceRow('Golo Coins (GC)', '-₹ 0'),

          taxRow('Tax(18%)', '₹ $totalTax', cgst, sgst),

          priceRow('Delivery Charges', '₹ $deliveryCharge'),

          const Divider(color: Colors.black),

          Row(
            children: [
              const Text('Total Amount', style: Constants.text1),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹ $bagTotal', style: Constants.text1),
                  const Text('(including all taxes)'),
                ],
              ),
            ],
          ),

          const Divider(),

          Row(
            children: [
              Text(
                'you will save ₹ $saving on this order',
                style: const TextStyle(color: Colors.green),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget taxRow(String label, String totalTax, var cgst, var sgst) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(label),
          Tooltip(
            message: 'CGST : ₹ $cgst, SGST : ₹ $sgst',
            preferBelow: false,
            showDuration: const Duration(seconds: 5),
            child: const InkWell(
                child: Icon(Icons.help, size: 16, color: Colors.grey)),
          ),
          const Spacer(),
          Text(
            totalTax,
            style: const TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget priceRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(label),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget oldPriceRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(label),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}



class CartController extends GetxController {
  var cartItemsCount = 0.obs;
  var totalCartPrice = 0.obs;

  getCartItemsCount() {
    cartItemsCount.value--;
  }
}
