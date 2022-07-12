import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bike_cafe/main.dart';
import 'package:bike_cafe/models/Cart_Model/cart_checkout_model.dart';
import 'package:bike_cafe/screens/Dashboard/Cart/cart.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'checkout.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  APIService service = APIService();

  // @override
  // void initState() {
  //   super.initState();
  //     // service.cartCheckoutApi(token: box1.get('data4'),userId: box1.get('data3'));
  // }

  //  String? _radioValue; //Initial definition of radio button value
  // String? choice;
  int? _radioSelected;
  String? _radioVal;
  TextWidgetStyle style = TextWidgetStyle();
  TextEditingController _controller = TextEditingController();

  ProductOrderController productController = Get.put(ProductOrderController());
  CartController cartController = Get.put(CartController());

  // ProductOrderController priceController = Get.put(ProductOrderController());

  @override
  Widget build(BuildContext context) {
    return box1.get("data4") == null
        ? const Center()
        : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const ScrollPhysics(),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        style.Roboto(
                            text: "Available offers",
                            size: 16,
                            fontwight: FontWeight.w400),
                        const SizedBox(height: 10),
                        ApplyCoupon(
                          token: box1.get('data4'),
                          userId: box1.get('data3'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        style.Roboto(
                            text: "Payment Option",
                            size: 16,
                            fontwight: FontWeight.w400),
                        const Divider(),
                        Row(children: [
                          Radio(
                            value: 1,
                            groupValue: _radioSelected,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                _radioSelected = value as int?;
                                _radioVal = 'Upi';
                              });
                              productController.paymentType.value =
                                  _radioSelected!;
                              debugPrint("after " +
                                  productController.paymentType.value
                                      .toString());
                            },
                          ),
                          const Text("Online Payment"),
                        ]),
                        Row(children: [
                          Radio(
                            value: 2,
                            groupValue: _radioSelected,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                _radioSelected = value as int?;
                                _radioVal = 'COD';
                              });
                              productController.paymentType.value =
                                  _radioSelected!;
                              debugPrint("after " +
                                  productController.paymentType.value
                                      .toString());
                            },
                          ),
                          const Text("Cash on Delivery"),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

//price container

//Apply coupon widget

}

class ApplyCoupon extends StatefulWidget {
  ApplyCoupon({Key? key, this.token, this.userId}) : super(key: key);

  String? token, userId;

  @override
  _ApplyCouponState createState() => _ApplyCouponState();
}

class _ApplyCouponState extends State<ApplyCoupon> {
  APIService service = APIService();
  int? _radioSelected;
  String? _radioVal;
  TextWidgetStyle style = TextWidgetStyle();
  TextEditingController _controller = TextEditingController();

  ProductOrderController productController = Get.put(ProductOrderController());
  CartController cartController = Get.put(CartController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    service.cartCheckoutApi(
        token: box1.get('data4'), userId: box1.get('data3'));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CartCheckoutModel?>(
      future: service.cartCheckoutApi(
        token: widget.token.toString(),
        userId: widget.userId.toString(),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          var totalCartItems = snapshot.data!.products!.length;
          if (snapshot.data!.coupons!.isNotEmpty) {
            var couponData = snapshot.data!.coupons;
            return Column(
              children: [
                Container(
                  height: 180,
                  child: ListView.builder(
                      itemCount: couponData?.length,
                      itemBuilder: (context, index) {
                        var coupons = snapshot.data!.coupons![index];
                        return Column(
                          children: [
                            // coupons.couponid==snapshot.data!.products[index].applyCouponId?
                            ListTile(
                                title: Text(coupons.couCode.toString()),
                                subtitle:
                                    Text(coupons.couDescription.toString()),
                                trailing: snapshot.data!.products![0]
                                            .applyCouponId !=
                                        coupons.couponid
                                    ? TextButton(
                                        onPressed: () async {
                                          await service.applycuponpost(
                                              token: box1.get('data4'),
                                              userId: box1.get('data3'),
                                              cuponid: coupons.couponid);
                                          service.cartCheckoutApi(
                                              token: box1.get('data4'),
                                              userId: box1.get('data3'));
                                          setState(() {

                                          });
                                        },
                                        child: Text('Apply'),
                                      )
                                    : TextButton(
                                        onPressed: () async {
                                          await service
                                              .cancelcupon(
                                                  token: box1.get('data4'),
                                                  userId: box1.get('data3'))
                                              .then((value) {
                                            setState(() {});
                                          });
                                          service.cartCheckoutApi(
                                              token: box1.get('data4'),
                                              userId: box1.get('data3'));
                                        },
                                        child: Text('Cancel'))),
                            Divider()
                          ],
                        );
                      }),
                ),
                priceWidget(snapshot, totalCartItems),
              ],
            );
          }
        } else {
          return const Center();
        }
        return SizedBox();
      },
    );
  }

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
    var deliveryCharge = checkout.deliverycharges == null
        ? 0
        : (checkout.deliverycharges).toStringAsFixed(2);

    productController.mrpPrice.value = totalMrp.toString();
    productController.savingAmount.value = saving.toString();
    productController.gstPrice.value = totalTax.toString();
    productController.cgstPrice.value = cgst.toString();
    productController.sgstPrice.value = sgst.toString();
    productController.totalPrice.value = bagTotal.toString();
    productController.productCount.value = totalItems.toString();
    productController.checkoutTotal.value = bagTotal.toInt();
    productController.deliveryFee.value = deliveryCharge.toString();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
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
                              text: '₹ $deliveryCharge',
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
}
