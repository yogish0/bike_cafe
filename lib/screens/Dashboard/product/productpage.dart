import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bike_cafe/models/Vechile/getbrand.dart';
import 'package:bike_cafe/models/Vechile/getmodel.dart';
import 'package:bike_cafe/models/Vechile/getvariant.dart';
import 'package:bike_cafe/models/Vechile/getvechiclebyuserid.dart';
import 'package:bike_cafe/models/Vechile/vechileDetailsModel.dart';
import 'package:bike_cafe/screens/Dashboard/product/locale/banner.dart';
import 'package:bike_cafe/screens/Dashboard/product/locale/tabbar.dart';
import 'package:bike_cafe/screens/Dashboard/product/screens/productview.dart';
import 'package:bike_cafe/screens/Dashboard/product/screens/servicepage.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/constrants.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';
import 'package:bike_cafe/widget/mysearchfield.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

class ProductPage extends StatelessWidget {
  ProductPage({Key? key, this.token, this.userId}) : super(key: key);

  String? token;
  String? userId;

  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      index: 6,
      title: "Your vehicle Products",
      body: ViewProduct(token: token, userId: userId),
    );
  }
}

class ViewProduct extends StatefulWidget {
  ViewProduct({Key? key, this.token, this.userId}) : super(key: key);

  String? token;
  String? userId;

  @override
  _ViewProductState createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  TextWidgetStyle style = TextWidgetStyle();

  Box? box1;

  @override
  void initState() {
    super.initState();
    createBox();

    service
        .getvechiledetailsbyuserid(
            token: widget.token, id: widget.userId.toString())
        ?.then((value) {
      if (value?.body.length != 0) {
        categoryController.selectedVariantId.value =
            value!.body[0].variantId.toString();
        categoryController.selectedVariantName.value =
            value.body[0].variantName.toString();
        setState(() {});
      } else {
        categoryController.selectedVariantId.value = '0';
      }
    });
  }

  void createBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {});
  }

  APIService service = APIService();

  @override
  Widget build(BuildContext context) {
    List<String> _vehicleVariant = [];
    String? selectedVariant;

    return box1?.get("data4") == null
        ? Constants.circularWidget()
        : SingleChildScrollView(
            child: SingleChildScrollView(
              // height: Config.Height,
              child: Column(
                children: [
                  // const BannerPage(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        style.Roboto(
                            text: "Result for",
                            color: Colors.black,
                            size: 16,
                            fontwight: FontWeight.w400),
                        // style.Roboto(
                        //     text: "Honda Splendor",
                        //     color: Colors.red,
                        //     size: 14,
                        //     fontwight: FontWeight.w400),
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 40),
                        //   child: IconButton(
                        //     onPressed: () {},
                        //     icon: Icon(Icons.arrow_drop_down_circle_outlined,
                        //         size: 15),
                        //   ),
                        // ),
                        const SizedBox(width: 8),

                        SizedBox(
                          width: Config.Width * 0.5,
                          child: FutureBuilder<GetVechiclebyuserid?>(
                            future: service.getvechiledetailsbyuserid(
                                token: box1?.get("data4"),
                                id: box1?.get("data3").toString()),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.body.isEmpty) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: const Text(' All Vehicles'),
                                    height: 50,
                                  );
                                } else {
                                  _vehicleVariant = ['All Vehicles'];
                                  for (var i = 0;
                                      i < snapshot.data!.body.length;
                                      i++) {
                                    _vehicleVariant.add(snapshot
                                        .data!.body[i].variantName
                                        .toString());
                                  }
                                  DropdownMenuItem<String> varient(String i) =>
                                      DropdownMenuItem(
                                        value: i,
                                        child: Text(i),
                                      );
                                  return Stack(
                                    children: [
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          items: _vehicleVariant
                                              .map(varient)
                                              .toList(),
                                          value: selectedVariant,
                                          onChanged: (selctedValue) {
                                            if (selctedValue ==
                                                'All Vehicles') {
                                              categoryController
                                                  .selectedVariantId
                                                  .value = '0';
                                              categoryController
                                                  .selectedVariantName
                                                  .value = 'All Vehicles';
                                              setState(() {});
                                              debugPrint(categoryController
                                                  .selectedVariantName.value);
                                            } else {
                                              debugPrint(selctedValue);
                                              var index =
                                                  _vehicleVariant.indexOf(
                                                      selctedValue.toString());
                                              debugPrint(snapshot.data!
                                                  .body[index - 1].variantName
                                                  .toString());
                                              debugPrint(snapshot.data!
                                                  .body[index - 1].variantId
                                                  .toString());

                                              setState(() {
                                                categoryController
                                                        .selectedVariantId
                                                        .value =
                                                    snapshot
                                                        .data!
                                                        .body[index - 1]
                                                        .variantId
                                                        .toString();
                                                categoryController
                                                        .selectedVariantName
                                                        .value =
                                                    snapshot
                                                        .data!
                                                        .body[index - 1]
                                                        .variantName
                                                        .toString();
                                              });
                                              debugPrint("variant name " +
                                                  categoryController
                                                      .selectedVariantName.value
                                                      .toString());
                                            }
                                          },
                                          // hint: Text('vehicle'),
                                          isExpanded: true,
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                            categoryController
                                                .selectedVariantName.value
                                                .toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        width: Config.Width * 0.4,
                                      )
                                    ],
                                  );
                                }
                              } else {
                                return const Center();
                              }
                            },
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            filterOptions();
                          },
                          child: Row(
                            children: [
                              style.Roboto(
                                  text: "Filter ",
                                  color: Colors.black,
                                  size: 12,
                                  fontwight: FontWeight.w400),
                              SvgPicture.asset("assets/img/svg/filter.svg")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  TabbarPage(
                    children: [
                      ProductViewPage(
                        token: box1!.get("data4"),
                        userId: box1!.get("data3"),
                      ),
                      ServicePage()
                    ],
                  )
                ],
              ),
            ),
          );
  }

  CategoryProductsController categoryController =
      Get.put(CategoryProductsController());

  //vehicle types lists
  List<String> _vehicleType = [];
  //vehicle brand list
  List<String> _vehicleBrand = [];
  //vehicle model list
  List<String> _vehicleModel = [];
  //vehicle variant list
  List<String> _vehicleVariant = [];

  TextEditingController vehicleType = TextEditingController();
  TextEditingController vehicleBrand = TextEditingController();
  TextEditingController vehicleModel = TextEditingController();
  TextEditingController vehicleVariant = TextEditingController();

  //ask adding to vehicle
  var addVehicle = false.obs;

  Future filterOptions() async {
    return Get.bottomSheet(
      SingleChildScrollView(
          child: Obx(
        () => Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Select vehicles to filter products"),
            ),
            const SizedBox(height: 15),
            //vehicle type search field
            FutureBuilder<Vechicletypemodel?>(
              future: service.getuservechiletype(token: box1?.get('data4')),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _vehicleType = [];
                  for (var i = 0; i < snapshot.data!.body.length; i++) {
                    _vehicleType.add(
                        snapshot.data!.body[i].vehcatVehicleType.toString());
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      height: 58,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black26),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: MySearchField(
                        suggestions: _vehicleType,
                        controller: vehicleType,
                        suggestionState: SuggestionState.enabled,
                        hint: 'Vehicle Type',
                        searchInputDecoration:
                            const InputDecoration(border: InputBorder.none),
                        onTap: (value) {
                          var index = _vehicleType.indexOf(value.toString());
                          categoryController.vehicleTypeId.value =
                              snapshot.data!.body[index].id.toString();
                          vehicleBrand.clear();
                          vehicleModel.clear();
                          vehicleVariant.clear();
                          setState(() {});
                        },
                      ),
                    ),
                  );
                } else {
                  return const Center();
                }
              },
            ),
            const SizedBox(height: 15),
            //vehicle brand search field
            FutureBuilder<VechiletypeBrand?>(
              future: service.getuserbrandbyvechicletype(
                  token: box1?.get('data4'),
                  vtypeid: categoryController.vehicleTypeId.value.toString()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _vehicleBrand = [];
                  for (var i = 0; i < snapshot.data!.body.length; i++) {
                    _vehicleBrand
                        .add(snapshot.data!.body[i].brandName.toString());
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      height: 58,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black26),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: MySearchField(
                        suggestions: _vehicleBrand,
                        controller: vehicleBrand,
                        suggestionState: SuggestionState.enabled,
                        hint: 'Vehicle Brand',
                        searchInputDecoration:
                            const InputDecoration(border: InputBorder.none),
                        onTap: (value) {
                          var index = _vehicleBrand.indexOf(value.toString());
                          categoryController.vehicleBrandId.value =
                              snapshot.data!.body[index].brandid.toString();
                          vehicleModel.clear();
                          vehicleVariant.clear();
                          setState(() {});
                        },
                      ),
                    ),
                  );
                } else {
                  return const Center();
                }
              },
            ),
            const SizedBox(height: 15),
            //vehicle model search field
            FutureBuilder<VechileModelByBrandId?>(
              future: service.getusermodelbybrandtype(
                  token: box1?.get('data4'),
                  brandid: categoryController.vehicleBrandId.value.toString()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _vehicleModel = [];
                  for (var i = 0; i < snapshot.data!.body.length; i++) {
                    _vehicleModel
                        .add(snapshot.data!.body[i].vehmodName.toString());
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      height: 58,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black26),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: MySearchField(
                        suggestions: _vehicleModel,
                        controller: vehicleModel,
                        suggestionState: SuggestionState.enabled,
                        hint: 'Vehicle Model',
                        searchInputDecoration:
                            const InputDecoration(border: InputBorder.none),
                        onTap: (value) {
                          var index = _vehicleModel.indexOf(value.toString());
                          categoryController.vehicleModelId.value =
                              snapshot.data!.body[index].id.toString();
                          vehicleVariant.clear();
                          setState(() {});
                          debugPrint(categoryController.vehicleModelId.value);
                        },
                      ),
                    ),
                  );
                } else {
                  return const Center();
                }
              },
            ),
            const SizedBox(height: 15),
            //vehicle variant search field
            FutureBuilder<VechilevariantType?>(
              future: service.getuservariantmodeltype(
                  token: box1?.get('data4'),
                  modelid: categoryController.vehicleModelId.value.toString()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _vehicleVariant = [];
                  for (var i = 0; i < snapshot.data!.body.length; i++) {
                    _vehicleVariant
                        .add(snapshot.data!.body[i].vehvarName.toString());
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      height: 58,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black26),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: MySearchField(
                        suggestions: _vehicleVariant,
                        controller: vehicleVariant,
                        suggestionState: SuggestionState.enabled,
                        hint: 'Vehicle Variant',
                        searchInputDecoration:
                            const InputDecoration(border: InputBorder.none),
                        onTap: (value) {
                          var index = _vehicleVariant.indexOf(value.toString());
                          categoryController.vehicleVariantId.value =
                              snapshot.data!.body[index].id.toString();
                          categoryController.selectedVariantId.value =
                              snapshot.data!.body[index].id.toString();
                          categoryController.selectedVariantName.value =
                              snapshot.data!.body[index].vehvarName.toString();
                          setState(() {});
                          debugPrint(
                              categoryController.selectedVariantId.value);
                        },
                      ),
                    ),
                  );
                } else {
                  return const Center();
                }
              },
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Checkbox(
                    value: addVehicle.value,
                    onChanged: (value) {
                      addVehicle.value = value!;
                      debugPrint(addVehicle.value.toString());
                    },
                  ),
                  const Text("Add vehicle to your profile")
                ],
              ),
            ),

            SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  if (addVehicle.value == true) {
                    service
                        .postvechilebyuser(
                            id: box1?.get('data3').toString(),
                            token: box1?.get('data4').toString(),
                            categoryid: categoryController.vehicleTypeId.value
                                .toString(),
                            brandid: categoryController.vehicleBrandId.value
                                .toString(),
                            variantid: categoryController.vehicleVariantId.value
                                .toString(),
                            modelid: categoryController.vehicleModelId.value
                                .toString(),
                            vehicleNumber: '')
                        .then((value) {
                      setState(() {});
                    });
                  } else {
                    // Get.back();
                  }
                  Get.back();
                },
                child: const Text("Apply"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      )),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
    );
  }
}
