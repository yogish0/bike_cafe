import 'package:flutter/material.dart';
import 'package:bike_cafe/models/Storage/address/availCityList.dart';
import 'package:bike_cafe/models/Storage/address/availableSt.dart';
import 'package:bike_cafe/models/Storage/address/postaddress.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';
import 'package:bike_cafe/widget/mysearchfield.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'addresspage.dart';

class EditAdressPage extends StatefulWidget {
  EditAdressPage({Key? key, this.routeName}) : super(key: key);

  String? routeName;

  @override
  _EditAdressPageState createState() => _EditAdressPageState();
}

class _EditAdressPageState extends State<EditAdressPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController alternatenumber = TextEditingController();
  TextEditingController addressText = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController state = TextEditingController();

  PostAddressModel? addressmodel;

  APIService apiService = APIService();

  bool defaultAddress = true;

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

  bool altNumberButton = true;
  bool altNumberText = false;

  CityStateController _cityStateController = Get.put(CityStateController());

  //states list
  List<String> _statesList = [];

  //cities list
  List<String> _citiesList = [];
  TextWidgetStyle style = TextWidgetStyle();

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      var addressApi = apiService.postaddress(
          responsemodel: addressmodel,
          token: box1!.get("data4"),
          id: box1!.get("data3"),
          name: name.text,
          number: number.text,
          altnumber: alternatenumber.text,
          address: addressText.text,
          landmark: landmark.text,
          city: _cityStateController.cityId.value,
          pincode: pincode.text,
          isDefault: defaultAddress ? '1' : '0');

      addressApi.then((value) {
        if(widget.routeName == null){
          Get.off(() => AddressPageList(routeName: '/myprofile'));
        }else{
          Get.off(() => AddressPageList(routeName: widget.routeName.toString()));
        }
      });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      title: "My Address",
      body: box1?.get("data4") == null
          ? const Center()
          : Scaffold(
              bottomNavigationBar: BottomAppBar(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: Config.Width * 0.45,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          name.clear();
                          number.clear();
                          alternatenumber.clear();
                          addressText.clear();
                          landmark.clear();
                          state.clear();
                          city.clear();
                          pincode.clear();
                        },
                        child: style.Roboto(
                            text: "Clear",
                            color: AppBarColor,
                            size: 14,
                            fontwight: FontWeight.w700),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kPrimaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50, width: 2),
                    SizedBox(
                      width: Config.Width * 0.45,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          validateAndSave();
                        },
                        child: style.Roboto(
                            text: "Save",
                            color: AppBarColor,
                            size: 14,
                            fontwight: FontWeight.w700),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kPrimaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFieldWidget2(
                            type: TextInputType.text,
                            controller: name,
                            textalign: TextAlign.center,
                            heading: "Full Name *",
                            validator: (input) {
                              if (input.toString().length <= 2) {
                                return 'Enter valid name.';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFieldWidget2(
                            type: TextInputType.number,
                            controller: number,
                            textalign: TextAlign.center,
                            heading: "Mobile Number *",
                            validator: (input) {
                              bool _isNumberValid = RegExp(r"^[6-9][0-9]{9}").hasMatch(input!);
                              if (!_isNumberValid) {
                                return 'Invalid phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                        Visibility(
                          visible: altNumberButton,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                altNumberButton = false;
                                altNumberText = true;
                              });
                            },
                            child: const Text('+ Add Alternate number'),
                          ),
                        ),
                        Visibility(
                          visible: altNumberText,
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                                child: TextFieldWidget2(
                                  type: TextInputType.number,
                                  controller: alternatenumber,
                                  textalign: TextAlign.center,
                                  heading: "Alternate Mobile Number",
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFieldWidget2(
                            type: TextInputType.multiline,
                            controller: addressText,
                            textalign: TextAlign.center,
                            heading: "Full Address *",
                            minLine: 3,
                            maxLine: null,
                            validator: (input) {
                              if (input.toString().length <= 10) {
                                return 'address should be atleast 10 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFieldWidget2(
                            type: TextInputType.text,
                            controller: landmark,
                            textalign: TextAlign.center,
                            heading: "Landmark *",
                            validator: (input) {
                              if (input.toString().length <= 10) {
                                return 'landmark should be atleast 10 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 1),
                                    blurRadius: 6.0),
                              ],
                            ),
                            child: FutureBuilder<GetStatesList?>(
                              future: apiService.getAddressStates(
                                  token: box1?.get("data4")),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  _statesList = [];
                                  for (var i = 0;i < snapshot.data!.statelists.length;i++) {
                                    _statesList.add(snapshot.data!.statelists[i].stateName.toString());
                                  }
                                  return MySearchField(
                                    suggestions: _statesList,
                                    suggestionState:
                                    SuggestionState.enabled,
                                    controller: state,
                                    hint: 'State *',
                                    searchInputDecoration: const InputDecoration(border: InputBorder.none,),
                                    searchStyle: const TextStyle(),
                                    onTap: (value) {
                                      var index = _statesList.indexOf(value.toString());
                                      _cityStateController.stateId.value = snapshot.data!.statelists[index].id.toString();
                                      setState(() {});
                                      debugPrint(_cityStateController.stateId.value);
                                      city.clear();
                                      _cityStateController.cityId.value = '0';
                                      pincode.clear();
                                    },
                                  );
                                } else {
                                  return const Center();
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 1),
                                    blurRadius: 6.0),
                              ],
                            ),
                            child: FutureBuilder<GetCitiesList?>(
                              future: apiService.getAddressCities(
                                  token: box1?.get("data4"),
                                  stateId: _cityStateController.stateId.value),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  _citiesList = [];
                                  for (var i = 0;i < snapshot.data!.cities.length;i++) {
                                    _citiesList.add(snapshot.data!.cities[i].cityName);
                                  }
                                  return MySearchField(
                                    suggestions: _citiesList,
                                    suggestionState:
                                    SuggestionState.enabled,
                                    controller: city,
                                    hint: 'City *',
                                    searchInputDecoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    searchStyle: const TextStyle(),
                                    onTap: (value) {
                                      var index = _citiesList.indexOf(value.toString());
                                      _cityStateController.cityId.value = snapshot.data!.cities[index].id.toString();
                                      setState(() {});
                                      debugPrint(_cityStateController.cityId.value);
                                      pincode.clear();
                                    },
                                  );
                                } else {
                                  return const Center();
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFieldWidget2(
                            type: TextInputType.number,
                            controller: pincode,
                            textalign: TextAlign.center,
                            heading: "PinCode *",
                            validator: (input) {
                              bool _isNumberValid = RegExp(r"^[0-9]{6}").hasMatch(input!);
                              if (!_isNumberValid) {
                                return 'Invalid pincode';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              Checkbox(
                                value: defaultAddress,
                                onChanged: (value) {
                                  setState(() {
                                    defaultAddress = value!;
                                  });
                                  debugPrint(defaultAddress.toString());
                                },
                              ),
                              const Text('Set as default delivery address',
                                  style: TextStyle(color: Colors.black54))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class CityStateController extends GetxController {
  var stateId = '0'.obs;
  var cityId = '0'.obs;
}

class TextFieldWidget2 extends StatelessWidget {
  TextFieldWidget2(
      {Key? key,
      this.heading,
      this.type,
      this.onSaved,
      this.controller,
      this.initialValue,
      this.textalign,
      this.minLine,
      this.maxLine,
      this.validator
      })
      : super(key: key);
  String? heading;
  final TextInputType? type;
  final onSaved;
  final TextEditingController? controller;
  final initialValue;
  final textalign;
  final minLine;
  final maxLine;
  final validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 1),
                  blurRadius: 6.0),
            ],
          ),
          child: TextFormField(
            textAlign: textalign,
            controller: controller,
            initialValue: initialValue,
            onSaved: onSaved,
            keyboardType: type,
            minLines: minLine,
            maxLines: maxLine,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: containerColor),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: containerColor),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 6),
              fillColor: Colors.white,
              filled: true,
              hintText: heading,
              hoverColor: Colors.black,
              border: InputBorder.none,
            ),
            validator: validator,
          ),
        )
      ],
    );
  }
}
