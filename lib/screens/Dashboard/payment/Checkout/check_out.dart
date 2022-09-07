import 'package:flutter/material.dart';
import 'package:bike_cafe/controllers/paymentcontroller.dart';
import 'package:bike_cafe/models/Cart_Model/cart_checkout_model.dart';
import 'package:bike_cafe/models/Storage/address/getaddressmodel.dart';
import 'package:bike_cafe/screens/Dashboard/Address/locale/addresspage.dart';
import 'package:bike_cafe/screens/Dashboard/Cart/cart.dart';
import 'package:bike_cafe/screens/Dashboard/payment/Checkout/payment_page.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/constrants.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  APIService service = APIService();
  GetAddressResponseModel? model;
  Box? box1;
  TextWidgetStyle style = TextWidgetStyle();

  @override
  void initState() {
    super.initState();
    createBox();
  }

  void createBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {});
  }

  ProductOrderController priceController = Get.put(ProductOrderController());
  CartController cartController = Get.put(CartController());
  final PaymentController paymentController = Get.put(PaymentController());

  bool isLoading = true;

  var cartLength = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      index: 6,
      title: "Checkout",
      body: box1?.get("data4") == null
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : Column(
              children: [
                Expanded(
                  // height: Config.Height * 0.73,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FutureBuilder<GetAddressResponseModel?>(
                          future: service.addressdata(
                              id: box1?.get("data3"),
                              token: box1?.get("data4")),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  for (var i = 0;
                                      i < snapshot.data!.addresses.length;
                                      i++)
                                    deliveryAddress(i, snapshot)
                                ],
                              );
                            } else {
                              return const Center();
                            }
                          },
                        ),
                        const SizedBox(height: 4),
                        // cart checkout details details
                        FutureBuilder<CartCheckoutModel?>(
                          future: service.cartCheckoutApi(
                              token: box1?.get("data4"),
                              userId: box1?.get("data3")),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              cartLength.value =
                                  snapshot.data!.products!.length;
                              return Column(
                                children: [
                                  for (var i = 0;
                                      i < snapshot.data!.products!.length;
                                      i++)
                                    cartLists(i, snapshot),
                                  const SizedBox(height: 4),
                                  priceDetailsWidget(
                                      snapshot, snapshot.data!.products!.length)
                                ],
                              );
                            } else {
                              return const Center();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Row(
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: Config.Width * 0.45,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            // priceController.paymentType.value = 0;
                            paymentController.paymentStatus.value = 0;
                            service
                                .cartCheckoutApi(
                                    token: box1?.get("data4"),
                                    userId: box1?.get("data3"))
                                .then((value) {
                              if (value?.success == "1") {
                                if (value!.products!.isNotEmpty) {
                                  Get.to(() => const PaymentPage2());
                                } else {
                                  Get.snackbar('No items found in cart',
                                      'Add items to cart',
                                      duration: const Duration(seconds: 3),
                                      backgroundColor:
                                          const Color.fromRGBO(0, 0, 0, 0.8),
                                      colorText: Colors.white);
                                }
                              }
                            });
                          },
                          child: const Text("Continue"),
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

  //Price Details widget

  Widget priceDetailsWidget(
      AsyncSnapshot<CartCheckoutModel?> snapshot, int totalItems) {
    var checkout = snapshot.data!;

    var bagTotal = checkout.grandTotal == null
        ? 0
        : checkout.grandTotal.toStringAsFixed(2);
    var totalMrp =
        checkout.totalMrp == null ? 0 : checkout.totalMrp.toStringAsFixed(2);
    var saving = checkout.savings ?? 0;
    var totalTax =
        checkout.totalTax == null ? 0 : (checkout.totalTax).toStringAsFixed(2);
    var cgst = checkout.cgst == null ? 0 : (checkout.cgst).toStringAsFixed(2);
    var sgst = checkout.sgst == null ? 0 : (checkout.sgst).toStringAsFixed(2);
    var deliveryCharge = checkout.deliverycharges == null
        ? 0
        : (checkout.deliverycharges).toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: Constants.bgwhitecolor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PRICE DETAILS', style: Constants.halfopacity),
          const Divider(),
          oldPriceRow(
              'Price ( ' + totalItems.toString() + ' items)', '₹ $totalMrp'),
          priceRow('Discount', '- ₹ $saving'),
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
            message: 'CGST : $cgst, and SGST : $sgst',
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

  //delivery address widget
  Widget deliveryAddress(
      int index, AsyncSnapshot<GetAddressResponseModel?> snapshot) {
    var address = snapshot.data!.addresses[index];

    return address.addIsDefault == 0
        ? const Center()
        : Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 4),
                  Expanded(
                    // width: Config.Width * 0.6,
                    child: Column(
                      children: [
                        const SizedBox(width: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Deliver to  '),
                            Expanded(
                              // width: Config.Width * 0.3,
                              child: Text(
                                address.name.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              ',' + address.addPincode.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
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
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => AddressPageList(routeName: '/checkoutpage'));
                    },
                    child: style.Roboto(
                        text: "Change",
                        color: AppBarColor,
                        size: 12,
                        fontwight: FontWeight.w700),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)))),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          );
  }

  //Cart List
  Widget cartLists(int index, AsyncSnapshot<CartCheckoutModel?> snapshot) {
    var products = snapshot.data!.products![index];

    return SizedBox(
      width: Config.Width,
      child: Column(
        children: [
          const SizedBox(height: 4),
          Card(
            margin: EdgeInsets.zero,
            child: Row(
              children: [
                //image
                Container(
                  width: Config.Width * 0.25,
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
                      InkWell(
                        child: Constants.IconText(
                            text: 'Remove', icontext: Icons.close),
                        onTap: () {
                          debugPrint('Removed');
                          Get.defaultDialog(
                            content: Text('Do yoy want to remove ' +
                                products.productname.toString() +
                                ' from cart'),
                            radius: 5,
                            onCancel: () {},
                            onConfirm: () {
                              var remove = service.removeCartItem(
                                  token: box1?.get("data4"),
                                  userId: box1?.get("data3").toString(),
                                  productId: products.productid.toString());
                              remove.then((value) {
                                service
                                    .cartCheckoutApi(
                                        token: box1?.get("data4"),
                                        userId: box1?.get("data3").toString())
                                    .then((value) {
                                  cartController.cartItemsCount.value =
                                      value!.products!.length;
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
                  width: Config.Width * 0.6,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        products.productname.toString(),
                        style: Constants.text0,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      //category text
                      Row(
                        children: [
                          const Text('category : ',
                              style: Constants.halfopacity),
                          Text(products.catName.toString(),
                              style: Constants.halfopacity),
                        ],
                      ),
                      const SizedBox(height: 5),

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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: InkWell(
                                      child: const Icon(
                                        Icons.remove,
                                        size: 16,
                                      ),
                                      onTap: () {
                                        if (products.cartQuantity > 1) {
                                          var decrement =
                                              service.decrementCartItemCount(
                                                  token: box1?.get("data4"),
                                                  userId: box1
                                                      ?.get("data3")
                                                      .toString(),
                                                  productId: products.productid
                                                      .toString());
                                          decrement.then((value) {
                                            setState(() {});
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Text(' ' +
                                      products.cartQuantity.toString() +
                                      ' '),
                                  //in 1 place, we need to pass total count
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: InkWell(
                                      child: const Icon(
                                        Icons.add,
                                        size: 16,
                                      ),
                                      onTap: () {
                                        var increment = service.addItemToCart(
                                            token: box1?.get("data4"),
                                            userId: box1?.get("data3"),
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
          const SizedBox(height: 4)
        ],
      ),
    );
  }
}

class ProductOrderController extends GetxController {
  var sellingPrice = 0.obs;
  var paymentType = 0.obs;

  //cart price details
  var productCount = '0'.obs;
  var mrpPrice = '0'.obs;
  var savingAmount = '0'.obs;
  var gstPrice = '0'.obs;
  var cgstPrice = '0'.obs;
  var sgstPrice = '0'.obs;
  var totalPrice = '0'.obs;
  var orderProcessing = false.obs;

  var checkoutTotal = 0.obs;
}
