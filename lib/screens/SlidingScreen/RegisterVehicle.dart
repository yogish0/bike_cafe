import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/models/Vechile/getbrand.dart';
import 'package:bike_cafe/models/Vechile/getmodel.dart';
import 'package:bike_cafe/models/Vechile/getvariant.dart';
import 'package:bike_cafe/models/Vechile/postVechicle.dart';
import 'package:bike_cafe/models/Vechile/vechileDetailsModel.dart';
import 'package:bike_cafe/screens/Dashboard/Home/dashboard.dart';
import 'package:bike_cafe/screens/SlidingScreen/vehicleList/listVehicle.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/auth/vector.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/mysearchfield.dart';
import 'package:hive/hive.dart';

class RegisterVehicle extends StatefulWidget {
  const RegisterVehicle({Key? key}) : super(key: key);

  @override
  State<RegisterVehicle> createState() => _RegisterVehicleState();
}

class _RegisterVehicleState extends State<RegisterVehicle> {
  final _formKey = GlobalKey<FormState>();
  String? model;
  String? brand;
  String? year;
  String? cc;
  String? img = '';
  String? valueChoose;
  PostVechileRequest? requestmodel;

  APIService service = APIService();

  int? vtype_id = 0;
  var btype_id = 0;
  int? modelid = 0;
  int? variant_id = 0;

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

  TextEditingController vehicleNumber = TextEditingController();
  TextEditingController _vehicleTypeText = TextEditingController();
  TextEditingController _vehicleBrandText = TextEditingController();
  TextEditingController _vehicleModelText = TextEditingController();
  TextEditingController _vehicleVariantText = TextEditingController();
  TextEditingController vehicleYear = TextEditingController();
  TextEditingController vehicleCC = TextEditingController();

  VehicleRegisterController vehicleRegisterController = Get.put(VehicleRegisterController());

  @override
  Widget build(BuildContext context) {


    //vehicle types lists
    List<String> _vehicleType = [];
    //vehicle brand list
    List<String> _vehicleBrand = [];
    //vehicle model list
    List<String> _vehicleModel = [];
    //vehicle variant list
    List<String> _vehicleVariant = [];

    vehicleYear.value = TextEditingValue(
        text: vehicleRegisterController.vehicleYear.value.toString());
    vehicleCC.value = TextEditingValue(
        text: vehicleRegisterController.vehicleCC.value.toString());

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: box1?.get("data4") == null
          ? Center(child: CircularProgressIndicator())
          : GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
              validate();
            },
            child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset("assets/img/some.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.chevron_left_sharp,
                                  size: 40, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 70, right: 20),
                        child: Vetcor(),
                      ),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: TextFormField(
                              controller: vehicleNumber,
                              textAlign: TextAlign.center,
                              decoration: validationDecor('Vehicle Number'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        //vehicle type search field
                        FutureBuilder<Vechicletypemodel?>(
                          future: service.getuservechiletype(
                              token: box1?.get('data4')),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              _vehicleType = [];
                              for (var i = 0;i < snapshot.data!.body.length;i++) {
                                _vehicleType.add(snapshot.data!.body[i].vehcatVehicleType.toString());
                              }
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: MySearchField(
                                    suggestions: _vehicleType,
                                    suggestionState: SuggestionState.enabled,
                                    hint: 'Vehicle Type',
                                    controller: _vehicleTypeText,
                                    searchInputDecoration: validationDecor(''),
                                    onTap: (value) {
                                      var index = _vehicleType.indexOf(value.toString());
                                      vehicleRegisterController.vehicleTypeId.value =
                                          snapshot.data!.body[index].id.toString();

                                      vehicleRegisterController.vehicleBrandId.value = '0';
                                      vehicleRegisterController.vehicleModelId.value = '0';
                                      vehicleRegisterController.vehicleVariantId.value = '0';
                                      vehicleRegisterController.vehicleYear.value = '';
                                      vehicleRegisterController.vehicleEndYear.value = '';
                                      vehicleRegisterController.vehicleCC.value = '';
                                      _vehicleBrandText.clear();
                                      _vehicleModelText.clear();
                                      _vehicleVariantText.clear();

                                      setState(() {});
                                    },
                                    validator: (input) {
                                      if (input.toString().length == 0) {
                                        return 'Select vehicle type';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return Center();
                            }
                          },
                        ),
                        const SizedBox(height: 5),
                        //vehicle brand search field
                        FutureBuilder<VechiletypeBrand?>(
                          future: service.getuserbrandbyvechicletype(
                              token: box1?.get('data4'),
                              vtypeid: vehicleRegisterController.vehicleTypeId.value.toString()),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              _vehicleBrand = [];
                              for (var i = 0;i < snapshot.data!.body.length;i++) {
                                _vehicleBrand.add(snapshot.data!.body[i].brandName.toString());
                              }
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: MySearchField(
                                    suggestions: _vehicleBrand,
                                    suggestionState: SuggestionState.enabled,
                                    hint: 'Vehicle Brand',
                                    controller: _vehicleBrandText,
                                    searchInputDecoration: validationDecor(''),
                                    onTap: (value) {
                                      var index = _vehicleBrand.indexOf(value.toString());
                                      vehicleRegisterController.vehicleBrandId.value =
                                          snapshot.data!.body[index].brandid.toString();

                                      vehicleRegisterController.vehicleModelId.value = '0';
                                      vehicleRegisterController.vehicleVariantId.value = '0';
                                      vehicleRegisterController.vehicleYear.value = '';
                                      vehicleRegisterController.vehicleEndYear.value = '';
                                      vehicleRegisterController.vehicleCC.value = '';
                                      _vehicleModelText.clear();
                                      _vehicleVariantText.clear();

                                      setState(() {});
                                    },
                                    validator: (input) {
                                      if (input.toString().length == 0) {
                                        return 'Select vehicle brand';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return Center();
                            }
                          },
                        ),
                        const SizedBox(height: 5),
                        //vehicle model search field
                        FutureBuilder<VechileModelByBrandId?>(
                          future: service.getusermodelbybrandtype(
                              token: box1?.get('data4'),
                              brandid: vehicleRegisterController.vehicleBrandId.value.toString()),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              _vehicleModel = [];
                              for (var i = 0;i < snapshot.data!.body.length;i++) {
                                _vehicleModel.add(snapshot.data!.body[i].vehmodName.toString());
                              }
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: MySearchField(
                                    suggestions: _vehicleModel,
                                    suggestionState: SuggestionState.enabled,
                                    hint: 'Vehicle Model',
                                    controller: _vehicleModelText,
                                    searchInputDecoration: validationDecor(''),
                                    onTap: (value) {
                                      var index = _vehicleModel.indexOf(value.toString());
                                      vehicleRegisterController.vehicleModelId.value = snapshot.data!.body[index].id.toString();

                                      vehicleRegisterController.vehicleVariantId.value = '0';
                                      vehicleRegisterController.vehicleYear.value = '';
                                      vehicleRegisterController.vehicleEndYear.value = '';
                                      vehicleRegisterController.vehicleCC.value = '';
                                      _vehicleVariantText.clear();
                                      setState(() {});
                                    },
                                    validator: (input) {
                                      if (input.toString().length == 0) {
                                        return 'Select vehicle model';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return Center();
                            }
                          },
                        ),
                        const SizedBox(height: 5),
                        //vehicle variant search field
                        FutureBuilder<VechilevariantType?>(
                          future: service.getuservariantmodeltype(
                              token: box1?.get('data4'),
                              modelid: vehicleRegisterController
                                  .vehicleModelId.value
                                  .toString()),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              _vehicleVariant = [];
                              for (var i = 0;
                                  i < snapshot.data!.body.length;
                                  i++) {
                                _vehicleVariant.add(
                                    snapshot.data!.body[i].vehvarName.toString());
                              }
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: MySearchField(
                                    suggestions: _vehicleVariant,
                                    suggestionState: SuggestionState.enabled,
                                    hint: 'Vehicle Variant',
                                    controller: _vehicleVariantText,
                                    searchInputDecoration: validationDecor(''),
                                    onTap: (value) {
                                      var index = _vehicleVariant
                                          .indexOf(value.toString());
                                      vehicleRegisterController.vehicleVariantId.value =
                                          snapshot.data!.body[index].id.toString();
                                      vehicleRegisterController.vehicleYear.value =
                                          snapshot.data!.body[index].vehvarLaunchYear.toString();
                                      vehicleRegisterController.vehicleEndYear.value =
                                          snapshot.data!.body[index].vehvarEndYear.toString();
                                      vehicleRegisterController.vehicleCC.value =
                                          snapshot.data!.body[index].vehvarCc.toString();
                                      setState(() {});
                                      print(vehicleRegisterController.vehicleVariantId.value);
                                    },
                                    validator: (input) {
                                      if (input.toString().length == 0) {
                                        return 'Select vehicle variant';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return Center();
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                color: containerColor,
                                border: Border.all(color: containerColor),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15))),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  vehicleRegisterController.vehicleYear.value == ''
                                      ? Text("Year", style: TextStyle(color: Color.fromRGBO(0,0,0,0.5),fontSize: 17),)
                                      : Text(vehicleRegisterController.vehicleYear.value.toString() + ' - ' , style: TextStyle(fontSize: 17)),
                                  vehicleRegisterController.vehicleEndYear.value == ''
                                      ? Text("")
                                      : vehicleRegisterController.vehicleEndYear.value == 'null'
                                      ? Text("" ,style: TextStyle(fontSize: 17))
                                      : Text(vehicleRegisterController.vehicleEndYear.value.toString(), style: TextStyle(fontSize: 17)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                color: containerColor,
                                border: Border.all(color: containerColor),
                                borderRadius: const BorderRadius.all(Radius.circular(15))),
                            child: Center(
                              child: vehicleRegisterController.vehicleCC.value == ''
                                  ? Text("CC", style: TextStyle(color: Color.fromRGBO(0,0,0,0.5),fontSize: 17),)
                                  : Text(vehicleRegisterController.vehicleCC.value.toString(), style: TextStyle(fontSize: 17)),
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FloatingActionButton(
                    backgroundColor: kPrimaryColor,
                    child: Icon(Icons.arrow_right_alt_rounded, size: 35),
                    onPressed: () {
                      // print("sucess1");
                      // Get.to(() => ListedVehicle());

                      validateAndSave();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        child: Text(
                          'Skip',
                          style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                        onPressed: () {
                          Get.off(() => Dashboard());
                        },
                      ),
                    ),
                  ),
                ],
              ),
          ),
    );
  }

  bool validate() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      service.postvechilebyuser(
          response: requestmodel,
          id: ' ${box1!.get('data3')}',
          token: box1!.get('data4'),
          categoryid: vehicleRegisterController.vehicleTypeId.value.toString(),
          brandid: vehicleRegisterController.vehicleBrandId.value.toString(),
          variantid: vehicleRegisterController.vehicleVariantId.value.toString(),
          modelid: vehicleRegisterController.vehicleModelId.value.toString(),
          vehicleNumber: vehicleNumber.text).then((value) {
        vehicleRegisterController.vehicleTypeId.value = '0';
        vehicleRegisterController.vehicleBrandId.value = '0';
        vehicleRegisterController.vehicleModelId.value = '0';
        vehicleRegisterController.vehicleVariantId.value = '0';
        vehicleRegisterController.vehicleYear.value ='';
        vehicleRegisterController.vehicleEndYear.value ='';
        vehicleRegisterController.vehicleCC.value = '';
        setState(() {});
        Get.to(() => ListedVehicle());
      });
      return true;
    }
    return false;
  }

  validationDecor(String? hintText) => InputDecoration(
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: containerColor),
        borderRadius: BorderRadius.all(Radius.circular(15))
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: containerColor),
        borderRadius: BorderRadius.all(Radius.circular(15))
    ),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(15))
    ),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(15))
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 12),
    fillColor: containerColor,
    filled: true,
    hoverColor: Colors.black,
    border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black26),
        borderRadius: BorderRadius.all(Radius.circular(15))
    ),
    hintText: hintText.toString()
  );
}

class VehicleRegisterController extends GetxController {
  var vehicleTypeId = '0'.obs;
  var vehicleBrandId = '0'.obs;
  var vehicleModelId = '0'.obs;
  var vehicleVariantId = '0'.obs;

  var vehicleYear = ''.obs;
  var vehicleEndYear = ''.obs;
  var vehicleCC = ''.obs;
}
