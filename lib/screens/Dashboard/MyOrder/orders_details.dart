import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bike_cafe/models/Order_Model/order_details_model.dart';
import 'package:bike_cafe/models/Storage/address/get_addressby_add_id_model.dart';
import 'package:bike_cafe/screens/Dashboard/MyOrder/rating_and_review_widget.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/constrants.dart';
import 'package:bike_cafe/widget/locale/downloadinvoice.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../models/Order_Model/TrackOrderByShipIdModel.dart';
import '../../chatbotScreen/chatbot.dart';

class OrdersDetails extends StatefulWidget {
  OrdersDetails({Key? key, this.ordersOrderId, this.ordersProductId})
      : super(key: key);

  @override
  _OrdersDetailsState createState() => _OrdersDetailsState();

  String? ordersOrderId, ordersProductId;
}

class _OrdersDetailsState extends State<OrdersDetails> {
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

  TextEditingController reviewTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      index: 6,
      title: "My Orders",
      body: box1?.get('data4') == null
          ? Constants.circularWidget()
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      FutureBuilder<GetOrdersDetails?>(
                        future: service.getUserOrdersDetails(
                            token: box1?.get('data4'),
                            userId: box1?.get('data3'),
                            orderId: widget.ordersOrderId.toString()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Constants.circularWidget();
                          } else if (snapshot.hasData) {
                            if (snapshot.data!.productorder.isNotEmpty) {
                              return orderViewWidget(snapshot);
                            } else {
                              return Container();
                            }
                          } else {
                            return Constants.circularWidget();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget orderViewWidget(AsyncSnapshot<GetOrdersDetails?> snapshot) {
    var productIndex = 0;
    var orderProduct;
    for (var i = 0; i < snapshot.data!.productorder.length; i++) {
      if (snapshot.data!.productorder[i].proordProductId.toString() ==
          widget.ordersProductId.toString()) {
        productIndex = i;
        orderProduct = snapshot.data!.productorder[i];
      }
    }
    return Column(
      children: [
        const SizedBox(height: 4),
        orderIdWidget(orderProduct),
        const SizedBox(height: 8),
        orderDetailsWidget(orderProduct),
        const SizedBox(height: 8),
        RatingAndReview(
          token: box1?.get('data4'),
          userId: box1?.get('data3'),
          orderId: widget.ordersOrderId.toString(),
          productId: widget.ordersProductId.toString(),
        ),
        const SizedBox(height: 8),
        shippingAndBillingAddresses(orderProduct.deliveryaddressId.toString()),
        const SizedBox(height: 8),
        snapshot.data!.productorder.length > 1
            ? Column(
                children: [
                  for (var i = 0; i < snapshot.data!.productorder.length; i++)
                    if (i != productIndex)
                      multipleProduct(snapshot.data!.productorder[i])
                ],
              )
            : Container(),
        const SizedBox(height: 8),
        orderSummaryWidget(orderProduct),
        const SizedBox(height: 12),
      ],
    );
  }

  //order details widget
  Widget orderIdWidget(Productorder orderProduct) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: Config.Width * 0.38,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                margin: const EdgeInsets.only(left: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Order Id : '),
                    SizedBox(height: 5),
                    Text('Order Date : '),
                    SizedBox(height: 5),
                    Text('Order Total : '),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(orderProduct.ordRefid.toString(),
                        style: Constants.redtext),
                    const SizedBox(height: 5),
                    Text(orderProduct.deliveryDate.toString(),
                        style: Constants.redtext),
                    const SizedBox(height: 5),
                    Text('₹ ' + orderProduct.proordPrice.toString(),
                        style: Constants.redtext),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.black),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
                onPressed: () {
                  //  log('ta'.toString());
                  // service.downloadinvoice(token: box1?.get('data4'),orderId:widget.ordersOrderId.toString() );
                  service.DownloadOrderInvoice(
                          token: box1?.get('data4'),
                          orderId: widget.ordersOrderId.toString())
                      .then((value) {
                    if (value?.isInvoiceCreated == true) {
                      DownloadInvoice download = DownloadInvoice();
                      download.openFile(value!.invoiceUrl.toString());
                    } else {
                      Fluttertoast.showToast(msg: "Unable to Download invoice");
                    }
                  });
                },
                child: Container(
                  child: const Text('Download Invoice'),
                  padding: const EdgeInsets.all(8),
                  //margin: EdgeInsets.symmetric(vertical: 4),
                ),
              ),
              const SizedBox(width: 6),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
                onPressed: () async {
                  await service.getShipRocketToken().then((value) {
                    if (value!.shiprocketToken != null) {
                      trackOrderModal(orderProduct.proordDeliveryRefid,
                          value.shiprocketToken);
                    }
                  });
                },
                child: const Text("Track Order"),
              )
            ],
          ),
          // SizedBox(height: 8,)
        ],
      ),
    );
  }

  // track order widget
  Future trackOrderModal(String? shipmentId, shipToken) async {
    return Get.bottomSheet(
      SingleChildScrollView(
        child: FutureBuilder<TrackOrderByShipIdModel?>(
          future: service.trackOrderByShipmentIdApi(
            shipmentId: shipmentId.toString(),
            token: shipToken.toString(),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              var trackData = snapshot.data!.trackingData;
              return snapshot.data!.trackingData.trackStatus == 0
                  ? SizedBox(
                      height: 300,
                      child: Center(
                        child: valueText("No tracking data present now..."),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            children: [
                              labelText("Tracking Id : "),
                              valueText(
                                  trackData.shipmentTrack![0].id.toString())
                            ],
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            children: [
                              labelText("Delivery Status : "),
                              Text(
                                  trackData.shipmentTrack![0].currentStatus
                                      .toString(),
                                  style: trackData
                                              .shipmentTrack![0].currentStatus
                                              .toString() ==
                                          "Delivered"
                                      ? const TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w400)
                                      : const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400))
                            ],
                          ),
                          const SizedBox(height: 6),
                          if (trackData.shipmentTrackActivities!.isNotEmpty)
                            Column(
                              children: [
                                for (int i = 0;
                                    i <
                                        trackData
                                            .shipmentTrackActivities!.length;
                                    i++)
                                  if (trackData.shipmentTrackActivities![i]
                                              .status ==
                                          "pickup_scheduled" ||
                                      trackData.shipmentTrackActivities![i]
                                              .status ==
                                          "pickup_complete" ||
                                      trackData.shipmentTrackActivities![i]
                                              .status ==
                                          "shipment_expected" ||
                                      trackData.shipmentTrackActivities![i]
                                              .status ==
                                          "out_for_delivery")
                                    TimelineTile(
                                      alignment: TimelineAlign.manual,
                                      lineXY: 0.1,
                                      isFirst: i == 0 ? true : false,
                                      isLast: i ==
                                              trackData.shipmentTrackActivities!
                                                      .length -
                                                  1
                                          ? true
                                          : false,
                                      afterLineStyle:
                                          const LineStyle(color: Colors.green),
                                      beforeLineStyle:
                                          const LineStyle(color: Colors.green),
                                      indicatorStyle: const IndicatorStyle(
                                          color: Colors.green),
                                      endChild: Container(
                                        margin: const EdgeInsets.only(
                                            left: 24, right: 6),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(trackData
                                                .shipmentTrackActivities![i]
                                                .srStatusLabel
                                                .toString()),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(trackData
                                                    .shipmentTrackActivities![i]
                                                    .date
                                                    .toString()
                                                    .substring(0, 10)),
                                                const SizedBox(width: 6),
                                                Text(trackData
                                                    .shipmentTrackActivities![i]
                                                    .date
                                                    .toString()
                                                    .substring(10, 16)),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                              ],
                            )
                        ],
                      ),
                    );
            } else {
              return SizedBox(
                height: 300,
                child: Center(
                  child: valueText("No tracking data present now..."),
                ),
              );
            }
          },
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
    );
  }

  Widget labelText(String text) {
    return Text(text,
        style: const TextStyle(
            fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w400));
  }

  Widget valueText(String text) {
    return Text(text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400));
  }

  //Order details
  Widget orderDetailsWidget(Productorder orderProduct) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: const Text('Order details'),
        ),
        const SizedBox(height: 4),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: orderProduct.proImagePath == null
                        ? SizedBox(
                            height: 70,
                            width: 70,
                            child: Image.asset(
                                "assets/img/no_image_available.jpg"),
                          )
                        : Image.network(orderProduct.proImagePath.toString(),
                            height: 70,
                            width: 70, errorBuilder: (context, img, image) {
                            return Image.asset(
                                "assets/img/no_image_available.jpg",
                                height: 70,
                                width: 70);
                          }),
                    padding: const EdgeInsets.all(8),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(orderProduct.proName.toString(),
                            style: Constants.text1),
                        const SizedBox(height: 8),
                        Text('Qty: ' + orderProduct.proordQuantity.toString(),
                            style: Constants.halfopacity),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        Text('₹ ' + orderProduct.proordPrice.toString(),
                            style: Constants.redtext),
                        const SizedBox(height: 30),
                      ],
                    ),
                  )
                ],
              ),
              // Container(
              //   decoration: const BoxDecoration(
              //       border: Border(
              //           top: BorderSide(color: Colors.black, width: 0.5))),
              //   child: Row(
              //     children: [
              //       Container(
              //         margin: const EdgeInsets.all(6),
              //         child: Column(
              //           children: [
              //             const Text('Estimated delivery'),
              //             const SizedBox(height: 4),
              //             Text(orderProduct.deliveryDate.toString(),
              //                 style: Constants.redtext),
              //           ],
              //         ),
              //       ),
              //       const Spacer(),
              //       InkWell(
              //         onTap: () {},
              //         child: Container(
              //           child: const Text('Track order'),
              //           padding: const EdgeInsets.all(8),
              //           //margin: EdgeInsets.symmetric(vertical: 4),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  // delivery address
  Widget shippingAddressWidget(Address addressData) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: const Text('Shipping address'),
        ),
        const SizedBox(height: 4),
        Card(
          margin: EdgeInsets.zero,
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(addressData.name.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                    )), //Full Name
                const SizedBox(height: 4),
                Text(addressData.addAddress.toString()),
                //House No./Building/Company/Apartment

                Text(addressData.addDescription.toString() +
                    ", " +
                    addressData.cityName.toString()),
                //Street, Area, Colony and city and Landmark

                Text(addressData.stateName.toString() +
                    " - " +
                    addressData.addPincode.toString()),
                // State and pincode

                const SizedBox(height: 10),
                Text(addressData.phonenumber.toString()),
                Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget billingAddressWidget(Address addressData) {
    return Column(
      children: [
        const SizedBox(height: 5),
        //billing address
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: const Text('Billing address'),
        ),
        const SizedBox(height: 4),
        Card(
          margin: EdgeInsets.zero,
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(addressData.name.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                    )), //Full Name
                const SizedBox(height: 4),
                Text(addressData.addAddress.toString()),
                //House No./Building/Company/Apartment

                Text(addressData.addDescription.toString() +
                    ", " +
                    addressData.cityName.toString()),
                //Street, Area, Colony and city and Landmark

                Text(addressData.stateName.toString() +
                    " - " +
                    addressData.addPincode.toString()),
                // State and pincode

                const SizedBox(height: 10),
                Text(addressData.phonenumber.toString()),
                Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget shippingAndBillingAddresses(String? addressId) {
    return FutureBuilder<GetAddressbyAddId?>(
      future: service.addressDataByAddId(
          token: box1?.get('data4'),
          userId: box1?.get('data3'),
          addressId: addressId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var addressData = snapshot.data!.address[0];
          return Column(
            children: [
              shippingAddressWidget(addressData),
              const SizedBox(height: 8),
              billingAddressWidget(addressData)
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  //remaining product list ordered with this product
  Widget multipleProduct(Productorder orderProduct) {
    return Column(
      children: [
        const SizedBox(height: 5),
        //billing address
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: const Text('Other items with this order'),
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: () {
            setState(() {
              widget.ordersOrderId = orderProduct.proordOrderId.toString();
              widget.ordersProductId = orderProduct.proordProductId.toString();
            });
          },
          child: Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      child: orderProduct.proImagePath == null
                          ? SizedBox(
                              height: 70,
                              width: 70,
                              child: Image.asset(
                                  "assets/img/no_image_available.jpg"),
                            )
                          : Image.network(orderProduct.proImagePath.toString(),
                              height: 70,
                              width: 70, errorBuilder: (context, img, image) {
                              return Image.asset(
                                  "assets/img/no_image_available.jpg",
                                  height: 70,
                                  width: 70);
                            }),
                      padding: const EdgeInsets.all(8),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(orderProduct.proName.toString(),
                              style: Constants.text1),
                          const SizedBox(height: 8),
                          Text(
                              'Qty: ' +
                                  orderProduct.packageItemsCount.toString(),
                              style: Constants.halfopacity),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          if (orderProduct.proordOrderStatusId != 1 &&
                              orderProduct.proordOrderStatusId != 9)
                            orderStatusWidget(orderProduct.proordOrderStatusId),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //order summary
  Widget orderSummaryWidget(Productorder orderProduct) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: const Text("Order Summary"),
        ),
        const SizedBox(height: 4),
        Card(
          margin: EdgeInsets.zero,
          child: Container(
            margin: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CheckoutWidgets.oldPriceRow('Price (1 items)', '₹ 499'),
                // CheckoutWidgets.priceRow('Discount', '-₹ 100'),
                // CheckoutWidgets.priceRow('Golo Coins (GC)', '-₹ 0'),
                // CheckoutWidgets.priceRow('Tax(18%)', '+₹ 30'),
                // CheckoutWidgets.priceRow('Delivery Charges', 'Free'),
                // const Divider(color: Colors.black),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Text(
                      'Total Amount',
                      style: Constants.text1,
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹ ' + orderProduct.proordPrice.toString(),
                          style: Constants.text1,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Payment by',
                      style: Constants.text1,
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          orderProduct.paymetName.toString(),
                          style: Constants.text1,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // const Text(
                //   'you saved ₹ 99 on this order',
                //   style: TextStyle(color: Colors.green),
                // ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Get.to(() => ChatBotPage(
                            orderId: orderProduct.proordOrderId.toString()));
                      },
                      child: const Text(
                        "Help?",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget orderStatusWidget(int? orderStatusId) {
    var orderStatusText = '';
    var orderStatusColor;
    var orderStatusTextColor;
    if (orderStatusId == 2 || orderStatusId == 3) {
      orderStatusText = "Processing";
      orderStatusColor = const Color.fromRGBO(255, 245, 235, 1);
      orderStatusTextColor = const Color.fromRGBO(251, 126, 21, 1);
    }
    if (orderStatusId == 4 || orderStatusId == 5) {
      orderStatusText = "In Transit";
      orderStatusColor = const Color.fromRGBO(217, 255, 244, 1);
      orderStatusTextColor = const Color.fromRGBO(21, 251, 182, 1);
    }
    if (orderStatusId == 6) {
      orderStatusText = "Delivered";
      orderStatusColor = const Color.fromRGBO(207, 255, 239, 1);
      orderStatusTextColor = const Color.fromRGBO(13, 160, 106, 1);
    }
    if (orderStatusId == 8) {
      orderStatusText = "Cancelled";
      orderStatusColor = const Color.fromRGBO(255, 150, 150, 1);
      orderStatusTextColor = const Color.fromRGBO(255, 245, 235, 1);
    }

    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        height: 40,
        decoration: BoxDecoration(
            color: orderStatusColor,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              orderStatusText,
              style: TextStyle(color: orderStatusTextColor),
            ),
          ),
        ),
      ),
    );
  }
}
