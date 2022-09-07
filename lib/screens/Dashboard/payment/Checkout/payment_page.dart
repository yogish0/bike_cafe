import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bike_cafe/controllers/paymentcontroller.dart';
import 'package:bike_cafe/models/Cart_Model/cart_checkout_model.dart';
import 'package:bike_cafe/screens/Dashboard/Cart/cart.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';
import 'package:hive/hive.dart';

import 'check_out.dart';
import 'order_details_page.dart';

class PaymentPage2 extends StatefulWidget {
  const PaymentPage2({Key? key}) : super(key: key);

  @override
  _PaymentPage2State createState() => _PaymentPage2State();
}

class _PaymentPage2State extends State<PaymentPage2> {
  APIService service = APIService();
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

  //  String? _radioValue; //Initial definition of radio button value
  // String? choice;
  int? _radioSelected;
  String? _radioVal;
  TextWidgetStyle style = TextWidgetStyle();
  TextEditingController _controller = TextEditingController();

  ProductOrderController productController = Get.put(ProductOrderController());
  CartController cartController = Get.put(CartController());
  final PaymentController paymentController = Get.put(PaymentController());
  // ProductOrderController priceController = Get.put(ProductOrderController());

  @override
  Widget build(BuildContext context) {
    return box1?.get("data4") == null
        ? const Center()
        : GetScaffold(
            index: 6,
            title: "Checkout",
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        offerWidget(),
                        const SizedBox(height: 4),
                        applyCouponWidget(),
                        const SizedBox(height: 4),
                        selectPaymentTypeWidget(),
                        const SizedBox(height: 4),
                        FutureBuilder<CartCheckoutModel?>(
                          future: service.cartCheckoutApi(
                              token: box1?.get("data4"),
                              userId: box1?.get("data3")),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var totalCartItems =
                                  snapshot.data!.products!.length;
                              return Column(
                                children: [
                                  priceWidget(snapshot, totalCartItems)
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
                          onPressed: () async {
                            if (productController.paymentType.value == 0) {
                              Fluttertoast.showToast(
                                  msg: "Select payment type");
                            }
                            if (productController.paymentType.value == 1) {
                              var initPayment =
                                  service.onlinePaymentInitiateApi(
                                      token: box1?.get("data4"),
                                      userId: box1?.get("data3"));
                              initPayment.then((value) {
                                if (value!.success == "1") {
                                  paymentController.goTransactionId.value =
                                      value.orders.gologixTranctionid
                                          .toString();
                                  paymentController.orderId.value =
                                      value.orders.orderid.toString();

                                  // razorpay payment calling
                                  paymentController.dispatchPayment(
                                      (productController.checkoutTotal.value *
                                          100),
                                      'Gologix Solution Private ltd.',
                                      box1?.get('data1'),
                                      "products",
                                      box1?.get('data2'),
                                      'Paytm');

                                  Get.to(() => const OrderDetails());

                                  // if(paymentController.paymentStatus.value != 0){
                                  //   Get.to(() => const OrderDetails());
                                  // }
                                }
                              });
                            }
                            if (productController.paymentType.value == 2) {
                              Get.to(() => const OrderDetails());
                            }
                          },
                          child: const Text("Place order"),
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

  //offers list widget
  Widget offerWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          style.Roboto(
              text: "Available offers", size: 16, fontwight: FontWeight.w400),
          const SizedBox(height: 10),
          Column(
            children: [
              for (var i = 0; i < 3; i++)
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            style.Roboto(
                                text: "5% Off on Engine oil", size: 12),
                            style.Roboto(
                                text: "Description About Offer",
                                size: 12,
                                color: Colors.grey),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 25,
                          child: ElevatedButton(
                            child: style.Roboto(text: "Apply", size: 12),
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              primary: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              child: const Text("View All Offers",
                  style: TextStyle(color: kPrimaryColor)),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  //payment option widget
  Widget selectPaymentTypeWidget() {
    return Container(
      padding: const EdgeInsets.all(4),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          style.Roboto(
              text: "Payment Option", size: 16, fontwight: FontWeight.w400),
          const Divider(),
          Row(
            children: [
              Radio(
                value: 1,
                groupValue: _radioSelected,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    _radioSelected = value as int?;
                    _radioVal = 'Upi';
                  });
                  productController.paymentType.value = value as int;
                  debugPrint("after " +
                      productController.paymentType.value.toString());
                },
              ),
              const Text("Online Payment"),
            ],
          ),
          // Row(children: [
          //   Radio(
          //     splashRadius: 2,
          //     value: 2,
          //     groupValue: _radioSelected,
          //     activeColor: kPrimaryColor,
          //     onChanged: (value) {
          //       setState(() {
          //         _radioSelected = value as int?;
          //
          //         _radioVal = 'Debit/Credit Card';
          //       });
          //     },
          //   ),
          //   Text("Debit/Credit Card"),
          // ]),
          // Row(children: [
          //   Radio(
          //     value: 3,
          //     groupValue: _radioSelected,
          //     activeColor: kPrimaryColor,
          //     onChanged: (value) {
          //       setState(() {
          //         _radioSelected = value as int?;
          //
          //         _radioVal = 'Net Banking';
          //       });
          //     },
          //   ),
          //   Text("Net Banking"),
          // ]),
          Row(
            children: [
              Radio(
                value: 2,
                groupValue: _radioSelected,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    _radioSelected = value as int?;
                    _radioVal = 'COD';
                  });
                  productController.paymentType.value = value as int;
                  debugPrint("after " +
                      productController.paymentType.value.toString());
                },
              ),
              const Text("Cash on Delivery"),
            ],
          ),
          // Row(children: [
          //   Radio(
          //     value: 5,
          //     groupValue: _radioSelected,
          //     activeColor: kPrimaryColor,
          //     onChanged: (value) {
          //       setState(() {
          //         _radioSelected = value as int?;
          //
          //         _radioVal = 'Use Gologix Coin';
          //       });
          //     },
          //   ),
          //   Text("Use Gologix Coins")
          // ]),
        ],
      ),
    );
  }

  //price container
  Widget priceWidget(
      AsyncSnapshot<CartCheckoutModel?> snapshot, int totalItems) {
    var checkout = snapshot.data!;

    var bagTotal = checkout.grandTotal == null ? 0 : checkout.grandTotal;
    var totalMrp =
        checkout.totalMrp == null ? 0 : checkout.totalMrp.toStringAsFixed(2);
    var saving =
        checkout.savings == null ? 0 : checkout.savings.toStringAsFixed(2);
    var totalTax =
        checkout.totalTax == null ? 0 : (checkout.totalTax).toStringAsFixed(2);
    var cgst = checkout.cgst == null ? 0 : (checkout.cgst).toStringAsFixed(2);
    var sgst = checkout.sgst == null ? 0 : (checkout.sgst).toStringAsFixed(2);

    productController.mrpPrice.value = totalMrp.toString();
    productController.savingAmount.value = saving.toString();
    productController.gstPrice.value = totalTax.toString();
    productController.cgstPrice.value = cgst.toString();
    productController.sgstPrice.value = sgst.toString();
    productController.totalPrice.value = bagTotal.toString();
    productController.productCount.value = totalItems.toString();
    productController.checkoutTotal.value = bagTotal.toInt();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: Colors.white,
      child: Column(
        children: [
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  style.OpenSans(
                      text: "PRICE DETAILS",
                      size: 16,
                      fontwight: FontWeight.w400),
                  const Divider(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          style.OpenSans(
                              text: "Price (" +
                                  totalItems.toString() +
                                  " items)", //("  + " item)
                              size: 12,
                              fontwight: FontWeight.w400),
                          style.OpenSans(
                              text: "₹ $totalMrp",
                              size: 12,
                              fontwight: FontWeight.w400,
                              color: Colors.red),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          style.OpenSans(
                              text: "Discount",
                              size: 12,
                              fontwight: FontWeight.w400),
                          style.OpenSans(
                              text: "- ₹ $saving",
                              size: 12,
                              fontwight: FontWeight.w400,
                              color: const Color.fromRGBO(0, 129, 0, 1)),
                        ],
                      ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     style.OpenSans(
                      //         text: "Golo Coins(GC)",
                      //         size: 12,
                      //         fontwight: FontWeight.w400),
                      //     style.OpenSans(
                      //         text: "-0.00",
                      //         size: 12,
                      //         fontwight: FontWeight.w400,
                      //         color: Color.fromRGBO(0, 129, 0, 1)),
                      //   ],
                      // ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          style.OpenSans(
                              text: "Tax(18%) ",
                              size: 12,
                              fontwight: FontWeight.w400),
                          Tooltip(
                            message: 'CGST: $cgst, and SGST: $sgst',
                            preferBelow: false,
                            showDuration: const Duration(seconds: 5),
                            child: const Icon(Icons.help,
                                size: 14, color: Colors.grey),
                          ),
                          const Spacer(),
                          style.OpenSans(
                              text: "₹ $totalTax",
                              size: 12,
                              fontwight: FontWeight.w400,
                              color: const Color.fromRGBO(0, 129, 0, 1)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          style.OpenSans(
                              text: "Delivery Fees",
                              size: 12,
                              fontwight: FontWeight.w400),
                          style.OpenSans(
                              text: "Free",
                              size: 12,
                              fontwight: FontWeight.w400,
                              color: const Color.fromRGBO(0, 129, 0, 1)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      style.OpenSans(
                          text: "Total Amount",
                          size: 12,
                          fontwight: FontWeight.w400),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          style.OpenSans(
                              text: "₹ $bagTotal",
                              size: 12,
                              fontwight: FontWeight.w400),
                          style.OpenSans(
                              text: "Incl of all taxes",
                              size: 12,
                              fontwight: FontWeight.w400),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  //Apply coupon widget
  Widget applyCouponWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Form(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Apply coupon code: '),
                    const SizedBox(height: 5),
                    Container(
                      height: 35,
                      width: 150,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(' '),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          //Get.to(EditAddress());
                        },
                        child: const Text('Apply'),
                        style: ElevatedButton.styleFrom(
                          primary: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
