import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bike_cafe/models/Order_Model/orders_by_id_model.dart';
import 'package:bike_cafe/screens/Dashboard/Home/dashboard.dart';
import 'package:bike_cafe/screens/Dashboard/product/locale/productviewdetails.dart';
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
      title: "My Orders",
      body: box1?.get('data4') == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<GetUserOrdersByIdModel?>(
                    future: service.getUserOrdersList(token: box1?.get('data4'), userId: box1?.get('data3')),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        if(snapshot.data!.order.isEmpty){
                          return emptyOrderWidget();
                        }else{
                          return Column(
                            children: [
                              buildSearchAndFilter(),
                              const SizedBox(height: 10),
                              if(searchController.text == "")
                                for(var i=0;i<snapshot.data!.order.length;i++)
                                  ordersList(i, snapshot)
                              else
                                for(var i=0;i<snapshot.data!.order.length;i++)
                                  if(snapshot.data!.order[i].proName!.toLowerCase().contains(searchController.text.toLowerCase()))
                                  ordersList(i, snapshot)

                            ],
                          );
                        }
                      }else{
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                ],
              )
            ),
    );
  }

  //search and filter container
  Widget buildSearchAndFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          //Search bar
          buildSearch(Config.Width * 0.7, 'Search your orders'),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => buildFilter(),
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const Text('Filter '),
                      SvgPicture.asset("assets/img/svg/filter.svg")
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
              setState(() {});
              debugPrint(searchController.text);
            },
            color: Colors.grey,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  var processing = false.obs;
  var inTransit = false.obs;
  var delivered = false.obs;

  Widget buildFilter() {
    return Obx(()=>Container(
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
                    onChanged: (value){
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
                    onChanged: (value){
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
                    onChanged: (value){
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

  Widget emptyOrderWidget(){
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
              onPressed: (){
                Get.to(()=> Dashboard());
              },
              child: const Text("Explore",style: TextStyle(fontSize: 20, color: kPrimaryColor)),
            )
          ],
        ),
      ),
    );
  }

  Widget ordersList(int index, AsyncSnapshot<GetUserOrdersByIdModel?> snapshot){
    var orders = snapshot.data!.order[index];
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  Get.to(()=> OrdersDetails(ordersOrderId: orders.orderid.toString(),
                    ordersProductId: orders.productid.toString()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      width: 100,
                      padding: const EdgeInsets.all(8),
                      child: Image.network(orders.proImagePath.toString())
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
                          if(orders.deliveryDate.toString() != "null")
                            Row(
                              children: [
                                const Text('Deliver by : ', style: Constants.halfopacity,),
                                Text(orders.deliveryDate.toString() != "null" ? orders.deliveryDate.toString() : '', style: Constants.halfopacity,)
                              ],
                            ),
                        ],
                      ),
                    ),
                    if(orders.ordStatusId != 1 && orders.ordStatusId != 9)
                      orderStatusWidget(orders.ordStatusId)
                  ],
                ),
              ),

              if(orders.ordStatusId != 1 && orders.ordStatusId != 8 && orders.ordStatusId != 9)
                Column(
                  children: [
                    const Divider(color: Colors.black),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: (){},
                          child: const Text("Download Invoice", style: TextStyle(color: Colors.black)),
                        ),
                        InkWell(
                          onTap: (){},
                          child: const Text("Track order", style: TextStyle(color: Colors.black)),
                        ),

                        if(orders.ordStatusId == 6)
                          InkWell(
                            onTap: (){
                              Get.to(()=>ProductViewDetails(token: box1?.get('data4'),productId: orders.productid,
                                  productName: orders.proName.toString()));
                            },
                            child: const Text("Buy again", style: TextStyle(color: Colors.black)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8)
                  ],
                )
            ],
          ),
        ),
        const SizedBox(height: 10)
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

