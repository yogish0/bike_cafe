import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/models/Storage/address/getaddressmodel.dart';
import 'package:bike_cafe/screens/Dashboard/Address/locale/editadress.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'address_edit.dart';

class AddressPageList extends StatefulWidget {
  AddressPageList({Key? key, this.routeName}) : super(key: key);

  String? routeName;

  @override
  State<AddressPageList> createState() => _AddressPageListState();
}

class _AddressPageListState extends State<AddressPageList> {
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

  @override
  Widget build(BuildContext context) {
    return box1?.get("data4") == null
        ? const Center()
        : GetScaffold(
          title: 'My Address',
          body: Scaffold(
              bottomNavigationBar: BottomAppBar(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      width: Config.Width,
                      height: 75,
                      child: Column(
                        children: [
                          const Text(
                            'Product will delivered to selected address',
                            style: TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Spacer(),
                              SizedBox(
                                width: Config.Width * 0.45,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if(widget.routeName == null){
                                      Get.back();
                                    }
                                    else{
                                      Get.offNamed(widget.routeName.toString());
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(kPrimaryColor),
                                  ),
                                  child: const Text("Continue", style: TextStyle(color: Colors.white))),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          SizedBox(
                            width: Config.Width * 0.7,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(() => EditAdressPage(routeName: widget.routeName == null ? '/myprofile' : widget.routeName.toString()));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(kPrimaryColor),
                              ),
                              child: const Text("+ Add New Address",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          "Saved Address",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                      ),
                      const Divider(),
                      FutureBuilder<GetAddressResponseModel?>(
                        future: apiservice.addressdata(
                            id: box1?.get("data3"), token: box1?.get("data4")),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                for (var i = 0;i < snapshot.data!.addresses.length;i++)
                                  listedAddress(i, snapshot)
                              ],
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
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

  // int? _groupValue = 0;

  Widget listedAddress(
      int index, AsyncSnapshot<GetAddressResponseModel?> snapshot) {
    var address = snapshot.data!.addresses[index];
    int? _groupValue;
    if (address.addIsDefault == 1) {
      _groupValue = index;
    }
    return Column(
      children: [
        Row(
          children: [
            Radio<int>(
              value: index,
              groupValue: _groupValue,
              onChanged: (value) {
                var update = apiservice.setDefaultAddress(
                    token: box1?.get("data4"),
                    userId: box1?.get("data3"),
                    addressId: address.addressId.toString());
                update.then((value) {
                  setState(() {});
                });
              },
            ),
            Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: Config.Width * 0.85,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              address.name.toString(),
                              style: const TextStyle(fontSize: 20),
                            ), //Full Name
                          ),
                          Text(address.addAddress.toString()),
                          //House No./Building/Company/Apartment

                          Text(address.addDescription.toString() +
                              ', ' +
                              address.cityName.toString()),
                          //Street, Area, Colony and city and Landmark

                          Text(address.stateName.toString() +
                              ' - ' +
                              address.addPincode.toString()),
                          // State and pincode

                          const SizedBox(height: 10),
                          Text(address.phonenumber.toString()),
                        ],
                      ),
                    ),

                    //Edit Option
                    Positioned(
                      top: -5,
                      right: 0,
                      child: TextButton(
                        onPressed: () {
                          Get.to(()=> AddressEditPage(token: box1?.get("data4"),
                              userId: box1?.get("data3"),
                              addressId: address.addressId.toString(),
                              routeName: widget.routeName == null ? '/myprofile' : widget.routeName.toString()));
                        }, //Edit Option
                        child: const Text('Edit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
