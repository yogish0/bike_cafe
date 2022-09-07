import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bike_cafe/controllers/paymentcontroller.dart';
import 'package:bike_cafe/models/Order_Model/online_payment_verify.dart';
import 'package:bike_cafe/models/Order_Model/order_details_model.dart';
import 'package:bike_cafe/models/Order_Model/order_response_model.dart';
import 'package:bike_cafe/models/Order_Model/orderdetailsmodeltwo.dart';
import 'package:bike_cafe/models/Storage/address/getaddressmodel.dart';
import 'package:bike_cafe/screens/Dashboard/Cart/cart.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

import 'checkout.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  APIService apiservice = APIService();
  GetAddressResponseModel? model;
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

  // ProductOrderController productController = Get.put(ProductOrderController());
  CartController cartController = Get.put(CartController());

  final PaymentController paymentController = Get.put(PaymentController());
  APIService service = APIService();

  @override
  Widget build(BuildContext context) {
    return box1?.get("data4") == null
        ? const Center()
        : Container(
            color: Colors.white,
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (productController.paymentType.value != 0)
                Container(
                  child:
                      //  productController.paymentType.value == 2
                      // ?
                      FutureBuilder<GetPaymentOrder?>(
                    future: service.getUserOrdersDetailsinorderlist(
                      orderId: box1!.get('orderId').toString(),
                      token: box1?.get("data4"),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.red),
                        );
                      }

                      return Column(
                        children: [
                          orderSuccessWidget(snapshot),
                          const SizedBox(height: 25),
                          addressWidget(),
                          const SizedBox(height: 25),
                          priceDetailsWidget(snapshot: snapshot),
                          const Divider(),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                  // :
                ),
              ],
            ),
          );
  }

  //int index, AsyncSnapshot<CartCheckoutModel?> snapshot, int totalItems
  Widget priceDetailsWidget(
      {required AsyncSnapshot<GetPaymentOrder?> snapshot}) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          style.OpenSans(
              text: "PRICE DETAILS", size: 16, fontwight: FontWeight.w400),
          const Divider(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     // style.OpenSans(
              //     //     text: "Price (" +
              //     //         snapshot.data.order[0].+
              //     //         " items)",
              //     //     size: 12,
              //     //     fontwight: FontWeight.w400),
              //     // style.OpenSans(
              //     //     text: "₹ " +  snapshot.data!.order[0].,
              //     //     size: 12,
              //     //     fontwight: FontWeight.w400,
              //     //     color: Colors.red),
              //   ],
              // ),
              const SizedBox(height: 4),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     style.OpenSans(
              //         text: "Discount", size: 12, fontwight: FontWeight.w400),
              //     style.OpenSans(
              //         text: "- ₹ " +
              //            snapshot.data!.productorder[0].proordPrice.toString(),
              //         size: 12,
              //         fontwight: FontWeight.w400,
              //         color: const Color.fromRGBO(0, 129, 0, 1)),
              //   ],
              // ),
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
                  // Tooltip(
                  //   message: "CGST: ₹ " +
                  //        snapshot.data!.order![0].tax.toString() +
                  //      ,
                  //   preferBelow: false,
                  //   showDuration: const Duration(seconds: 5),
                  //   child: const Icon(Icons.help, size: 14, color: Colors.grey),
                  // ),
                  const Spacer(),
                  style.OpenSans(
                      text: "₹ " + snapshot.data!.order![0].tax.toString(),
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
                      text: "₹ " +
                          snapshot.data!.order![0].deliveryfee.toString(),
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
                  text: "₹ " + snapshot.data!.order![0].total.toString(),
                  size: 12,
                  fontwight: FontWeight.w400),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              style.OpenSans(
                  text: "Payment Mode", size: 12, fontwight: FontWeight.w400),
              style.OpenSans(
                  text: snapshot.data!.order![0].paymentMethod.toString(),
                  size: 12,
                  fontwight: FontWeight.w400),
            ],
          ),
        ],
      ),
    );
  }

  Widget addressWidget() {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Delivery Address"),
          const Divider(),
          FutureBuilder<GetAddressResponseModel?>(
            future: apiservice.addressdata(
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

  //order success widget for cash on delivery
  Widget orderSuccessWidget(AsyncSnapshot<GetPaymentOrder?> snapshot) {
    return Container(
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
          style.Roboto(
              text: "Thanks for your order",
              size: 16,
              fontwight: FontWeight.w400,
              color: const Color.fromRGBO(0, 129, 0, 1)),
          const SizedBox(height: 18),
          style.Roboto(
              text: "your order number ", size: 16, fontwight: FontWeight.w700),
          const SizedBox(height: 8),
          style.Roboto(
              text: snapshot.data!.order![0].orderRefId.toString(),
              size: 24,
              fontwight: FontWeight.w700,
              color: kPrimaryColor),
          const SizedBox(height: 18),
          style.Roboto(
              text: "Visit Again", size: 16, fontwight: FontWeight.w400),
        ],
      ),
    );
  }

  Widget orderPaymentSuccessWidget(
      AsyncSnapshot<VerifyOnlinePaymentModel?> snapshot) {
    return Container(
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
          style.Roboto(
              text: "Thanks for your order",
              size: 16,
              fontwight: FontWeight.w400,
              color: const Color.fromRGBO(0, 129, 0, 1)),
          const SizedBox(height: 18),
          style.Roboto(
              text: "Transaction id :", size: 16, fontwight: FontWeight.w700),
          const SizedBox(height: 8),
          style.Roboto(
              text: paymentController.payment_id.toString(),
              size: 18,
              fontwight: FontWeight.w700),
          const SizedBox(height: 18),
          style.Roboto(
              text: "your order number ", size: 16, fontwight: FontWeight.w700),
          const SizedBox(height: 8),
          style.Roboto(
              text: snapshot.data!.orders.orderrefid.toString(),
              size: 24,
              fontwight: FontWeight.w700,
              color: kPrimaryColor),
          const SizedBox(height: 18),
          style.Roboto(
              text: "Visit Again", size: 16, fontwight: FontWeight.w400),
        ],
      ),
    );
  }

  Widget orderFailureWidget(AsyncSnapshot<VerifyOnlinePaymentModel?> snapshot) {
    return Container(
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
                Icons.close,
                size: 20,
                color: Colors.white,
              )),
            ),
          ),
          const SizedBox(height: 10),
          style.Roboto(
              text: "Payment failed",
              size: 16,
              fontwight: FontWeight.w400,
              color: const Color.fromRGBO(190, 0, 0, 1)),
          const SizedBox(height: 18),
          const SizedBox(height: 18),
          style.Roboto(
              text: "Transaction id :", size: 16, fontwight: FontWeight.w700),
          const SizedBox(height: 8),
          style.Roboto(
              text: paymentController.failedPaymentId.toString(),
              size: 18,
              fontwight: FontWeight.w700),
        ],
      ),
    );
  }

  Future<void> pushOrderMethod(String orderId) async {
    service
        .pushOrderApi(token: box1?.get("data4"), orderId: orderId)
        .then((value) {
      debugPrint("push order api...");
      debugPrint(value?.shipmentId.toString());
      if (value?.shipmentId != null) {
        service
            .storeShipmentIdApi(
                token: box1?.get("data4"),
                orderId: orderId,
                shipmentId: value?.shipmentId.toString())
            .then((value) {
          debugPrint("store shipment id api...");
          debugPrint(value?.message.toString());
        });
      }
    });
  }
}
