import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bike_cafe/models/Order_Model/orders_by_id_model.dart';
import 'package:bike_cafe/screens/Dashboard/Home/dashboard.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/constrants.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'orders_details.dart';

class OrdersListPage extends StatefulWidget {
  const OrdersListPage({Key? key}) : super(key: key);

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
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

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      index: 6,
      title: "My Orders",
      body: box1?.get('data4') == null
          ? Center(child: Constants.circularWidget())
          : FutureBuilder<GetUserOrdersByIdModel?>(
              future: service.getUserOrdersList(
                  token: box1?.get('data4'), userId: box1?.get('data3')),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Constants.circularWidget();
                }
                if (snapshot.hasData) {
                  if (snapshot.data!.order.isEmpty) {
                    return emptyOrderWidget();
                  } else {
                    return OrdersList(snapshot: snapshot);
                  }
                } else {
                  // return Constants.circularWidget();
                  return Center();
                }
              },
            ),
    );
  }

  var processing = false.obs;
  var inTransit = false.obs;
  var delivered = false.obs;

  Widget buildFilter() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter by order status'),
            const Divider(),
            StaggeredGrid.count(
              crossAxisCount: Config.Width ~/ 120,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: delivered.value,
                      onChanged: (value) {
                        setState(() {
                          delivered.value = value!;
                        });
                        debugPrint('delivered = $delivered');
                      },
                    ),
                    const Text('delivered')
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: inTransit.value,
                      onChanged: (value) {
                        setState(() {
                          inTransit.value = value!;
                        });
                        debugPrint('inTransit = $inTransit');
                      },
                    ),
                    const Text('inTransit')
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: processing.value,
                      onChanged: (value) {
                        setState(() {
                          processing.value = value!;
                        });
                        debugPrint("processing = $processing");
                      },
                    ),
                    const Text('Processing')
                  ],
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Filter'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget emptyOrderWidget() {
    return SizedBox(
      height: Config.Height * 0.8,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "You didn't ordered anything yet.",
              style: TextStyle(fontSize: 20),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => Dashboard());
              },
              child: const Text("Explore",
                  style: TextStyle(fontSize: 20, color: kPrimaryColor)),
            )
          ],
        ),
      ),
    );
  }
}

class OrdersList extends StatefulWidget {
  OrdersList({Key? key, required this.snapshot}) : super(key: key);

  AsyncSnapshot<GetUserOrdersByIdModel?> snapshot;

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  TextEditingController searchController = TextEditingController();

  late List ordersData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ordersData = widget.snapshot.data!.order;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSearchAndFilter(),
        const SizedBox(height: 6),
        Expanded(
          child: ListView.builder(
            itemCount: ordersData.length,
            itemBuilder: (context, index) {
              var item = ordersData[index];
              return ordersList(item);
            },
          ),
        ),
      ],
    );
  }

  Widget buildSearch(double wid, String hintText) {
    return Container(
      width: wid,
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // setState(() {});
              debugPrint(searchController.text);
            },
            color: Colors.grey,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
        onChanged: searchOrder,
      ),
    );
  }

  // filter by search
  void searchOrder(String query) {
    final suggestions = widget.snapshot.data!.order.where((element) {
      final orderTitle = element.proName.toString().toLowerCase();
      final inputText = query.toLowerCase();

      return orderTitle.contains(inputText);
    }).toList();

    setState(() {
      ordersData = suggestions;
    });
  }

  Widget buildSearchAndFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          //Search bar
          buildSearch(Config.Width * 0.9, 'Search your orders'),
          // const Spacer(),
          // Container(
          //   margin: const EdgeInsets.only(left: 8),
          //   child: Row(
          //     children: [
          //       InkWell(
          //         onTap: () {
          //           showModalBottomSheet(
          //             context: context,
          //             builder: (context) => buildFilter(),
          //             isScrollControlled: true,
          //             shape: const RoundedRectangleBorder(
          //               borderRadius:
          //                   BorderRadius.vertical(top: Radius.circular(15)),
          //             ),
          //           );
          //         },
          //         child: Row(
          //           children: [
          //             const Text('Filter '),
          //             SvgPicture.asset("assets/img/svg/filter.svg")
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget ordersList(Order orders) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => OrdersDetails(
                      ordersOrderId: orders.orderid.toString(),
                      ordersProductId: orders.productid.toString()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      width: 100,
                      padding: const EdgeInsets.all(8),
                      child: Image.network(
                        orders.proImagePath.toString(),
                        errorBuilder: (context, img, image) {
                          return Image.asset(
                              "assets/img/no_image_available.jpg");
                        },
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(orders.proName.toString(),
                              style: Constants.text0,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text(
                                'Order Id : ',
                                style: Constants.halfopacity,
                              ),
                              Text(
                                orders.ordRefid.toString(),
                                style: Constants.halfopacity,
                              ),
                            ],
                          ),
                          // if (orders.deliveryDate.toString() != "null")
                          //   Row(
                          //     children: [
                          //       const Text(
                          //         'Deliver by : ',
                          //         style: Constants.halfopacity,
                          //       ),
                          //       Text(
                          //         orders.deliveryDate.toString() != "null"
                          //             ? orders.deliveryDate.toString()
                          //             : '',
                          //         style: Constants.halfopacity,
                          //       ),
                          //     ],
                          //   ),
                          // if (orders.ordStatusId != 1 &&
                          //     orders.ordStatusId != 9)
                          //   orderStatusWidget(orders.ordStatusId)
                        ],
                      ),
                    ),
                    // Card(
                    //   color: kPrimaryColor,
                    //   child: InkWell(
                    //     onTap: () {},
                    //     child: const Padding(
                    //       padding: EdgeInsets.all(8),
                    //       child: Text("Track Order",
                    //           style: TextStyle(color: Colors.white)),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10)
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

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      height: 40,
      // decoration: BoxDecoration(
      //     color: orderStatusColor,
      //     borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          orderStatusText,
          style: TextStyle(color: orderStatusTextColor),
        ),
      ),
    );
  }

  Widget buildFilter() {
    return Container();
  }
}
