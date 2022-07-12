import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

import '../../chatbotScreen/chatbot.dart';

class OrdersDetails extends StatefulWidget {
  OrdersDetails({Key? key, this.ordersOrderId, this.ordersProductId}) : super(key: key);

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
      title: "My Orders",
      body: box1?.get('data4') == null
          ? const Center(child: CircularProgressIndicator())
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
                          if (snapshot.hasData) {
                            if (snapshot.data!.productorder.isNotEmpty) {
                              return orderViewWidget(snapshot);
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
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
          token: box1?.get('data4'), userId: box1?.get('data3'),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Text(orderProduct.deliveryDate.toString(), style: Constants.redtext),
                    const SizedBox(height: 5),
                    Text('₹ ' + orderProduct.proordPrice.toString(),
                        style: Constants.redtext),
                  ],
                ),
              ),
            ],
          ),
          Divider(color: Colors.black,),
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
            onPressed: () {
              log('ta'.toString());
              DownloadInvoice invoice=DownloadInvoice();
              invoice.openFile('http://www.africau.edu/images/default/sample.pdf');
            },
            child: Container(
              child: const Text('Download Invoice'),
              padding: const EdgeInsets.all(8),
              //margin: EdgeInsets.symmetric(vertical: 4),
            ),
          ),
          SizedBox(height: 8,)
        ],
      ),
    );
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
                        Text(
                            'Qty: ' + orderProduct.proordQuantity.toString(),
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
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black, width: 0.5))),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(6),
                      child: Column(
                        children: [
                          const Text('Estimated delivery'),
                          const SizedBox(height: 4),
                          Text(orderProduct.deliveryDate.toString(), style: Constants.redtext),
                        ],
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        child: const Text('Track order'),
                        padding: const EdgeInsets.all(8),
                        //margin: EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
                  ],
                ),
              ),
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
          onTap: (){
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
                              'Qty: ' + orderProduct.packageItemsCount.toString(),
                              style: Constants.halfopacity),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          if(orderProduct.proordOrderStatusId != 1 && orderProduct.proordOrderStatusId != 9)
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
                const Divider(color: Colors.black),
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
                const Text(
                  'you saved ₹ 99 on this order',
                  style: TextStyle(color: Colors.green),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: (){
                        Get.to(()=> ChatBotPage(orderId: orderProduct.proordOrderId.toString()));
                      },
                      child: const Text("Help?"),
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

  Widget orderStatusWidget(int? orderStatusId){
    var orderStatusText = '';
    var orderStatusColor;
    var orderStatusTextColor;
    if(orderStatusId == 2 || orderStatusId == 3){
      orderStatusText = "Processing";
      orderStatusColor = const Color.fromRGBO(255, 245, 235, 1);
      orderStatusTextColor = const Color.fromRGBO(251, 126, 21, 1);
    }
    if(orderStatusId == 4 || orderStatusId == 5) {
      orderStatusText = "In Transit";
      orderStatusColor = const Color.fromRGBO(217, 255, 244, 1);
      orderStatusTextColor = const Color.fromRGBO(21, 251, 182, 1);
    }
    if(orderStatusId == 6){
      orderStatusText = "Delivered";
      orderStatusColor = const Color.fromRGBO(207, 255, 239, 1);
      orderStatusTextColor = const Color.fromRGBO(13, 160, 106, 1);
    }
    if(orderStatusId == 8){
      orderStatusText = "Cancelled";
      orderStatusColor = const Color.fromRGBO(255, 150, 150, 1);
      orderStatusTextColor = const Color.fromRGBO(255, 245, 235, 1);
    }

    return InkWell(
      onTap: (){},
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        height: 40,
        decoration: BoxDecoration(
            color: orderStatusColor, borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(orderStatusText, style: TextStyle(color: orderStatusTextColor),),
          ),
        ),
      ),
    );
  }
}