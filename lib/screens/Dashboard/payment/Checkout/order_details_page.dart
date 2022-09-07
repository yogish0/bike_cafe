import 'package:flutter/material.dart';
import 'package:bike_cafe/controllers/paymentcontroller.dart';
import 'package:bike_cafe/models/Order_Model/online_payment_verify.dart';
import 'package:bike_cafe/models/Order_Model/order_response_model.dart';
import 'package:bike_cafe/models/Storage/address/getaddressmodel.dart';
import 'package:bike_cafe/screens/Dashboard/Home/dashboard.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/constrants.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';
import 'package:hive/hive.dart';
import 'check_out.dart';
import 'package:get/get.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
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

  ProductOrderController productController = Get.put(ProductOrderController());
  final PaymentController paymentController = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      index: 6,
      title: "Checkout",
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (productController.paymentType.value != 0)
              Obx(
                () => Container(
                  child: productController.paymentType.value == 2
                      ? FutureBuilder<OrderResponseModel?>(
                          future: service.codPaymentOrderApi(
                              token: box1?.get("data4"),
                              userId: box1?.get("data3")),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.orders.success.toString() ==
                                  '1') {
                                return Column(
                                  children: [
                                    orderSuccessWidget(snapshot),
                                    const SizedBox(height: 10),
                                    addressWidget(),
                                    const SizedBox(height: 10),
                                    priceDetailsWidget(),
                                  ],
                                );
                              } else {
                                return Center(
                                  child: Text(
                                      snapshot.data!.orders.message.toString()),
                                );
                              }
                            } else {
                              return Center(
                                child: Column(
                                  children: [
                                    Text(paymentController.paymentStatus
                                        .toString()),
                                    Text(paymentController.payment_id
                                        .toString()),
                                  ],
                                ),
                              );
                            }
                          },
                        )
                      : paymentController.paymentStatus.value != 0
                          ? paymentController.paymentStatus.value == 1
                              ? FutureBuilder<VerifyOnlinePaymentModel?>(
                                  future: service.onlinePaymentVerifyApi(
                                      token: box1?.get("data4"),
                                      userId: box1?.get("data3"),
                                      goTransactionId: paymentController
                                          .goTransactionId.value
                                          .toString(),
                                      orderId: paymentController.orderId.value
                                          .toString(),
                                      paymentTransactionId: paymentController
                                          .payment_id
                                          .toString(),
                                      paymentStatus: "1"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Column(
                                        children: [
                                          orderSuccessOnlinePaymentWidget(
                                              snapshot),
                                          const SizedBox(height: 10),
                                          addressWidget(),
                                          const SizedBox(height: 10),
                                          priceDetailsWidget(),
                                        ],
                                      );
                                    } else {
                                      return const Center();
                                    }
                                  },
                                )
                              : FutureBuilder<VerifyOnlinePaymentModel?>(
                                  future: service.onlinePaymentVerifyApi(
                                      token: box1?.get("data4"),
                                      userId: box1?.get("data3"),
                                      goTransactionId: paymentController
                                          .goTransactionId.value
                                          .toString(),
                                      orderId: paymentController.orderId.value
                                          .toString(),
                                      paymentTransactionId: paymentController
                                          .failedPaymentId
                                          .toString(),
                                      paymentStatus: "0"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Column(
                                        children: [
                                          onlinePaymentFailedWidget(snapshot)
                                        ],
                                      );
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                )
                          : Container(),
                ),
              )
          ],
        ),
      ),
    );
  }

  //order success widget for cash on delivery
  Widget orderSuccessWidget(AsyncSnapshot<OrderResponseModel?> snapshot) {
    return Container(
      color: Constants.bgwhitecolor,
      padding: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 10),
          Card(
            color: const Color.fromRGBO(0, 128, 0, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: const SizedBox(
              height: 40,
              width: 40,
              child: Center(
                  child: Icon(
                Icons.done,
                size: 20,
                color: Colors.white,
              )),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Thanks for your order",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 129, 0, 1)),
          ),
          const SizedBox(height: 18),
          const Text(
            "your order number",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            snapshot.data!.orders.orderrefid.toString(),
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor),
          ),
          const SizedBox(height: 18),
          const Text(
            "Visit Again",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              Get.to(() => Dashboard());
            },
            child: const Text("Continue shopping",
                style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  //order success widget for online payment
  Widget orderSuccessOnlinePaymentWidget(
      AsyncSnapshot<VerifyOnlinePaymentModel?> snapshot) {
    return Container(
      color: Constants.bgwhitecolor,
      padding: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 10),
          Card(
            color: const Color.fromRGBO(0, 128, 0, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: const SizedBox(
              height: 40,
              width: 40,
              child: Center(
                  child: Icon(
                Icons.done,
                size: 20,
                color: Colors.white,
              )),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Thanks for your order",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 129, 0, 1)),
          ),
          const SizedBox(height: 18),
          const Text(
            "your order number",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            snapshot.data!.orders.orderrefid.toString(),
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor),
          ),
          const SizedBox(height: 18),
          const Text(
            "Transaction id",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            paymentController.payment_id.toString(),
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor),
          ),
          const SizedBox(height: 18),
          const Text(
            "Visit Again",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              Get.to(() => Dashboard());
            },
            child: const Text("Continue shopping",
                style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  //order success widget for cash on delivery
  Widget onlinePaymentFailedWidget(
      AsyncSnapshot<VerifyOnlinePaymentModel?> snapshot) {
    //AsyncSnapshot<OrderResponseModel?> snapshot
    return Container(
      color: Constants.bgwhitecolor,
      padding: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 10),
          Card(
            color: const Color.fromRGBO(190, 0, 0, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: const SizedBox(
              height: 40,
              width: 40,
              child: Center(
                  child: Icon(
                Icons.clear,
                size: 20,
                color: Colors.white,
              )),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Payment failed",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(190, 0, 0, 1)),
          ),
          const SizedBox(height: 18),
          const Text(
            "Transaction id",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            paymentController.failedPaymentId.toString(),
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor),
          ),
          const SizedBox(height: 18),
          OutlinedButton(
            onPressed: () {
              Get.to(() => Dashboard());
            },
            child: const Text("Continue shopping",
                style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget addressWidget() {
    return Container(
      color: Constants.bgwhitecolor,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Delivery Address"),
          const Divider(),
          FutureBuilder<GetAddressResponseModel?>(
            future: service.addressdata(
                id: box1?.get("data3"), token: box1?.get("data4")),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    for (var i = 0; i < snapshot.data!.addresses.length; i++)
                      deliveryAddress(i, snapshot)
                  ],
                );
              } else {
                return const Center();
              }
            },
          ),
        ],
      ),
    );
  }

  TextWidgetStyle style = TextWidgetStyle();

  Widget deliveryAddress(
      int index, AsyncSnapshot<GetAddressResponseModel?> snapshot) {
    var address = snapshot.data!.addresses[index];
    return address.addIsDefault == 0
        ? const Center()
        : Column(
            children: [
              SizedBox(
                width: Config.Width * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: style.OpenSans(
                          text: address.name.toString(), size: 14), //Full Name
                    ),
                    style.OpenSans(
                        text: address.addAddress.toString(), size: 12),

                    style.OpenSans(
                        text: address.addDescription.toString() +
                            ', ' +
                            address.cityName.toString(),
                        size: 12),

                    style.OpenSans(
                        text: address.stateName.toString() +
                            ' - ' +
                            address.addPincode.toString(),
                        size: 12),

                    const SizedBox(height: 10),
                    // State and pincode
                    style.OpenSans(
                        text: address.phonenumber.toString(), size: 12),
                  ],
                ),
              ),
            ],
          );
  }

  Widget priceDetailsWidget() {
    return Container(
      color: Constants.bgwhitecolor,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          style.OpenSans(
              text: "PRICE DETAILS", size: 16, fontwight: FontWeight.w400),
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
                          productController.productCount.value.toString() +
                          " items)",
                      size: 12,
                      fontwight: FontWeight.w400),
                  style.OpenSans(
                      text: "₹ " + productController.mrpPrice.value.toString(),
                      size: 12,
                      fontwight: FontWeight.w400,
                      color: Colors.red),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  style.OpenSans(
                      text: "Discount", size: 12, fontwight: FontWeight.w400),
                  style.OpenSans(
                      text: "- ₹ " +
                          productController.savingAmount.value.toString(),
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
                      text: "Tax(18%) ", size: 12, fontwight: FontWeight.w400),
                  Tooltip(
                    message: "CGST: ₹ " +
                        productController.cgstPrice.value.toString() +
                        "and SGST: ₹ " +
                        productController.sgstPrice.value.toString(),
                    preferBelow: false,
                    showDuration: const Duration(seconds: 5),
                    child: const Icon(Icons.help, size: 14, color: Colors.grey),
                  ),
                  const Spacer(),
                  style.OpenSans(
                      text: "₹ " + productController.gstPrice.value.toString(),
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
                  // Text("Delivery Fees"), Text("Free")
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
                  text: "Total Amount", size: 12, fontwight: FontWeight.w400),
              style.OpenSans(
                  text: "₹ " + productController.totalPrice.value.toString(),
                  size: 12,
                  fontwight: FontWeight.w400),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              style.OpenSans(
                  text: "Payment Mode", size: 12, fontwight: FontWeight.w400),
              style.OpenSans(
                  text: productController.paymentType.value == 1
                      ? "Online Payment"
                      : "Cash on Delivery",
                  size: 12,
                  fontwight: FontWeight.w400),
            ],
          ),
        ],
      ),
    );
  }
}
