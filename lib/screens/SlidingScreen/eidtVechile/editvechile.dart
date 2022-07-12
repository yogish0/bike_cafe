import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/models/Vechile/getbrand.dart';
import 'package:bike_cafe/models/Vechile/getmodel.dart';
import 'package:bike_cafe/models/Vechile/getvariant.dart';
import 'package:bike_cafe/models/Vechile/getvechiclebyuserid.dart';
import 'package:bike_cafe/models/Vechile/vechileDetailsModel.dart';
import 'package:bike_cafe/screens/Dashboard/profile/locale/gallery_widget.dart';
import 'package:bike_cafe/screens/SlidingScreen/vehicleList/listVehicle.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/auth/vector.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/mysearchfield.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class EditVeichle extends StatefulWidget {
  const EditVeichle({Key? key, this.token, this.userId, this.vehicleId}) : super(key: key);

  final String? token;
  final String? userId;
  final String? vehicleId;

  @override
  _EditVeichleState createState() => _EditVeichleState();
}

class _EditVeichleState extends State<EditVeichle> {
  final _formKey = GlobalKey<FormState>();
  APIService service = APIService();
  bool isLoading = true;

  File? image;
  final picker = ImagePicker();

  //pick image from gallery/camera
  Future pickImage(ImageSource imgSource, String? token, String? userId,
      String vehicleId) async {
    final PickedFile = await picker.pickImage(source: imgSource, imageQuality: 50);
    if (PickedFile != null) {
      image = File(PickedFile.path);
      if (image != null) {
        service.vehicleImageUploadApi(
            token: token, userId: userId, vehicleId: vehicleId, img: image!).then((value) {
          setState(() {});
          Fluttertoast.showToast(msg: "Vehicle image updated");
        });
      }
      setState(() {});
    } else {
      debugPrint('no image selected');
    }
  }

  var vehicleImgUrl;

  TextEditingController vehicleNumber = TextEditingController();
  TextEditingController vehicleType = TextEditingController();
  TextEditingController vehicleBrand = TextEditingController();
  TextEditingController vehicleModel = TextEditingController();
  TextEditingController vehicleVariant = TextEditingController();
  TextEditingController vehicleYear = TextEditingController();
  TextEditingController vehicleCC = TextEditingController();

  VehicleEditController vehicleEditController = Get.put(VehicleEditController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    service.getVehicleDetailsByUseridVehicleId(token: widget.token.toString(),
        userId: widget.userId.toString(), vehicleId: widget.vehicleId.toString())?.then((value) {
          var vehicle = value?.body[0];
      setState(() {
        vehicleNumber.value = vehicle!.usevehVehicleNumber == null
            ? const TextEditingValue(text: '')
            : TextEditingValue(text: vehicle.usevehVehicleNumber.toString());
        vehicleType.value = TextEditingValue(text: vehicle.vehicleTypeName.toString());
        vehicleBrand.value = TextEditingValue(text: vehicle.brandname.toString());
        vehicleModel.value = TextEditingValue(text: vehicle.modelName.toString());
        vehicleVariant.value = TextEditingValue(text: vehicle.variantName.toString());
        vehicleEditController.vehicleTypeId.value = vehicle.vehicleTypeId.toString();
        vehicleEditController.vehicleBrandId.value = vehicle.brandid.toString();
        vehicleEditController.vehicleModelId.value = vehicle.modelId.toString();
        vehicleEditController.vehicleVariantId.value = vehicle.variantId.toString();
        vehicleEditController.vehicleYear.value = vehicle.launchYear.toString();
        vehicleEditController.vehicleEndYear.value = vehicle.endYear.toString();
        vehicleEditController.vehicleCC.value = vehicle.cc.toString();
      });
    });
  }

  //vehicle types lists
  List<String> _vehicleType = [];
  //vehicle brand list
  List<String> _vehicleBrand = [];
  //vehicle model list
  List<String> _vehicleModel = [];
  //vehicle variant list
  List<String> _vehicleVariant = [];


  @override
  Widget build(BuildContext context) {
    vehicleYear.value = TextEditingValue(
        text: vehicleEditController.vehicleYear.value.toString());
    vehicleCC.value = TextEditingValue(
        text: vehicleEditController.vehicleCC.value.toString());

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
          validate();
        },
        child: ListView(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Stack(children: [
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
                      icon: const Icon(
                        Icons.chevron_left_sharp,
                        size: 40,
                        color: Colors.white,
                      )),
                )
              ]),
              Padding(
                padding: const EdgeInsets.only(bottom: 70, right: 20),
                child: Vetcor(),
              )
            ]),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // imgContainer(vehicleEditController.vehicleImgUrl.value),
                  FutureBuilder<GetVechiclebyuserid?>(
                    future: service.getVehicleDetailsByUseridVehicleId(token: widget.token.toString(),
                        userId: widget.userId.toString(), vehicleId: widget.vehicleId.toString()),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return imgContainer(snapshot.data?.body[0].vehicleImage.toString());
                      }else{
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: TextFormField(
                        controller: vehicleNumber,
                        textAlign: TextAlign.center,
                        decoration: validationDecor("Vehicle Number"),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 5),
                  //vehicle type search field
                  FutureBuilder<Vechicletypemodel?>(
                    future: service.getuservechiletype(
                        token: widget.token),
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
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: MySearchField(
                              suggestions: _vehicleType,
                              suggestionState: SuggestionState.enabled,
                              controller: vehicleType,
                              hint: 'Vehicle Type',
                              searchInputDecoration: validationDecor(''),
                              onTap: (value) {
                                var index = _vehicleType.indexOf(value.toString());
                                vehicleEditController.vehicleTypeId.value = snapshot.data!.body[index].id.toString();
                                vehicleEditController.vehicleBrandId.value = '0';
                                vehicleEditController.vehicleModelId.value = '0';
                                vehicleEditController.vehicleVariantId.value = '0';
                                vehicleEditController.vehicleYear.value = '';
                                vehicleEditController.vehicleEndYear.value = '';
                                vehicleEditController.vehicleCC.value = '';
                                vehicleBrand.clear();
                                vehicleModel.clear();
                                vehicleVariant.clear();
                                setState(() {});
                                debugPrint("vehicle type: "+vehicleEditController.vehicleTypeId.value.toString());
                              },
                              validator: (input) {
                                if (input.toString().isEmpty) {
                                  return 'Select vehicle type';
                                }
                                return null;
                              },
                            ),
                          ),
                        );
                      } else {
                        return const Center();
                      }
                    },
                  ),
                  const SizedBox(height: 5),
                  //vehicle brand search field
                  FutureBuilder<VechiletypeBrand?>(
                    future: service.getuserbrandbyvechicletype(
                        token: widget.token,
                        vtypeid: vehicleEditController.vehicleTypeId.value.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _vehicleBrand = [];
                        for (var i = 0;i < snapshot.data!.body.length; i++) {
                          _vehicleBrand.add(snapshot.data!.body[i].brandName.toString());
                        }
                        return Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: MySearchField(
                              suggestions: _vehicleBrand,
                              suggestionState: SuggestionState.enabled,
                              controller: vehicleBrand,
                              hint: 'Vehicle Brand',
                              searchInputDecoration: validationDecor(''),
                              onTap: (value) {
                                var index = _vehicleBrand.indexOf(value.toString());
                                vehicleEditController.vehicleBrandId.value = snapshot.data!.body[index].brandid.toString();

                                vehicleEditController.vehicleModelId.value = '0';
                                vehicleEditController.vehicleVariantId.value = '0';
                                vehicleEditController.vehicleYear.value = '';
                                vehicleEditController.vehicleEndYear.value = '';
                                vehicleEditController.vehicleCC.value = '';
                                vehicleModel.clear();
                                vehicleVariant.clear();

                                setState(() {});
                                debugPrint("brand: "+vehicleEditController.vehicleBrandId.value.toString());
                              },
                              validator: (input) {
                                if (input.toString().isEmpty) {
                                  return 'Select vehicle brand';
                                }
                                return null;
                              },
                            ),
                          ),
                        );
                      } else {
                        return const Center();
                      }
                    },
                  ),
                  const SizedBox(height: 5),
                  //vehicle model search field
                  FutureBuilder<VechileModelByBrandId?>(
                    future: service.getusermodelbybrandtype(
                        token: widget.token,
                        brandid: vehicleEditController
                            .vehicleBrandId.value
                            .toString()),
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
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: MySearchField(
                              suggestions: _vehicleModel,
                              suggestionState: SuggestionState.enabled,
                              hint: 'Vehicle Model',
                              controller: vehicleModel,
                              searchInputDecoration: validationDecor(''),
                              onTap: (value) {
                                var index =
                                _vehicleModel.indexOf(value.toString());
                                vehicleEditController.vehicleModelId.value = snapshot.data!.body[index].id.toString();

                                vehicleEditController.vehicleVariantId.value = '0';
                                vehicleEditController.vehicleYear.value = '';
                                vehicleEditController.vehicleEndYear.value = '';
                                vehicleEditController.vehicleCC.value = '';
                                vehicleVariant.clear();
                                setState(() {});
                                debugPrint("model: "+vehicleEditController.vehicleModelId.value.toString());
                              },
                              validator: (input) {
                                if (input.toString().isEmpty) {
                                  return 'Select vehicle model';
                                }
                                return null;
                              },
                            ),
                          ),
                        );
                      } else {
                        return const Center();
                      }
                    },
                  ),
                  const SizedBox(height: 5),
                  //vehicle variant search field
                  FutureBuilder<VechilevariantType?>(
                    future: service.getuservariantmodeltype(
                        token: widget.token,
                        modelid: vehicleEditController.vehicleModelId.value.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _vehicleVariant = [];
                        for (var i = 0;i < snapshot.data!.body.length;i++) {
                          _vehicleVariant.add(snapshot.data!.body[i].vehvarName.toString());
                        }
                        return Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: MySearchField(
                              suggestions: _vehicleVariant,
                              suggestionState: SuggestionState.enabled,
                              hint: 'Vehicle Variant',
                              controller: vehicleVariant,
                              searchInputDecoration: validationDecor(''),
                              onTap: (value) {
                                var index = _vehicleVariant.indexOf(value.toString());
                                vehicleEditController.vehicleVariantId.value = snapshot.data!.body[index].id.toString();
                                vehicleEditController.vehicleYear.value = snapshot.data!.body[index].vehvarLaunchYear.toString();
                                vehicleEditController.vehicleEndYear.value = snapshot.data!.body[index].vehvarLaunchYear.toString();
                                vehicleEditController.vehicleCC.value = snapshot.data!.body[index].vehvarCc.toString();
                                setState(() {});
                                debugPrint("variant: "+vehicleEditController.vehicleVariantId.value.toString());
                              },
                              validator: (input) {
                                if (input.toString().isEmpty) {
                                  return 'Select vehicle variant';
                                }
                                return null;
                              },
                            ),
                          ),
                        );
                      } else {
                        return const Center();
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: containerColor,
                          border: Border.all(color: containerColor),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            vehicleEditController.vehicleYear.value == ''
                                ? const Text("Year", style: TextStyle(color: Color.fromRGBO(0,0,0,0.5),fontSize: 17),)
                                : Text(vehicleEditController.vehicleYear.value.toString() + ' - ' , style: const TextStyle(fontSize: 17)),
                            vehicleEditController.vehicleEndYear.value == ''
                                ? const Text("")
                                : vehicleEditController.vehicleEndYear.value == 'null'
                                ? const Text("" ,style: TextStyle(fontSize: 17))
                                : Text(vehicleEditController.vehicleEndYear.value.toString(), style: const TextStyle(fontSize: 17)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: containerColor,
                          border: Border.all(color: containerColor),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                      child: Center(
                        child: vehicleEditController.vehicleCC.value == ''
                            ? const Text("CC", style: TextStyle(color: Color.fromRGBO(0,0,0,0.5),fontSize: 17),)
                            : Text(vehicleEditController.vehicleCC.value.toString(), style: const TextStyle(fontSize: 17)),
                      )
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Config.Height * 0.03),
            FloatingActionButton(
              backgroundColor: kPrimaryColor,
              child: const Icon(
                Icons.arrow_right_alt_rounded,
                size: 35,
              ),
              onPressed: () {
                validateAndSave();
              },
            ),

            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }

  Widget imgContainer(String? vechileImg) {
    var imageList = [
      // "https://msilonline.in" + vechileImg.toString(),
      "http://3.109.69.39" + vechileImg.toString(),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: SizedBox(
        height: 150,
        width: 180,
        child: Stack(
          children: [
            vechileImg == "null"
                ? Image.asset("assets/img/no_image_available.jpg")
                : Center(
                child: InkWell(
                  onTap: (){
                    Get.to(() => GalleryWidget(urlImages: imageList));
                  },
                  child: Image.network(
                      // "https://msilonline.in" + vechileImg.toString(),
                    "http://3.109.69.39" + vechileImg.toString(),
                      width: 130,errorBuilder: (context, img, image){
                    return Image.asset("assets/img/no_image_available.jpg");
                  },),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  color: kPrimaryColor,
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => uploadOptions(),
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                    );
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
      service.editVehicleByUserVehicleIdApi(
          token: widget.token.toString(),
          userId: widget.userId.toString(),
          vehicleId: widget.vehicleId.toString(),
          vehicleTypeId: vehicleEditController.vehicleTypeId.value.toString(),
          brandId: vehicleEditController.vehicleBrandId.value.toString(),
          modelId: vehicleEditController.vehicleModelId.value.toString(),
          variantId: vehicleEditController.vehicleVariantId.value.toString(),
          vehicleNumber: vehicleNumber.text.toString()
      ).then((value) {
        if(value?.success == "1"){
          Get.off(()=> ListedVehicle());
        }
      });
      return true;
    }
    return false;
  }

  validationDecor(String? hintText) => InputDecoration(
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: containerColor),
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: containerColor),
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      fillColor: containerColor,
      filled: true,
      hoverColor: Colors.black,
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      hintText: hintText.toString()
  );


  bool cameraPermission = false;
  bool storagePermission = false;

  //ask permission for camera
  void checkCameraPermission(String vehicleId) async{
    if (await Permission.camera.request().isGranted) {
      setState(() {
        cameraPermission = true;
      });
      pickImage(ImageSource.camera, widget.token,
          widget.userId, vehicleId.toString());
    } else if (await Permission.camera.request().isPermanentlyDenied) {
      await openAppSettings();
      debugPrint('object3');
    } else if (await Permission.camera.request().isDenied) {
      debugPrint('object4');

      setState(() {
        cameraPermission = false;
      });
    }
  }

  //ask permission for storage
  void checkStoragePermission(String vehicleId) async{
    if (await Permission.storage.request().isGranted) {
      setState(() {
        storagePermission = true;
      });
      pickImage(ImageSource.gallery, widget.token,
          widget.userId, vehicleId.toString());
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
      debugPrint('object3');
    } else if (await Permission.storage.request().isDenied) {
      debugPrint('object4');

      setState(() {
        storagePermission = false;
      });
    }
  }

  //image upload options
  Widget uploadOptions() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              // pickImage(ImageSource.camera, widget.token,
              //     widget.userId, widget.vehicleId.toString());
              checkCameraPermission(widget.vehicleId.toString());
              Get.back();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.camera_alt, size: 30),
                SizedBox(height: 4),
                Text('Camera')
              ],
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: () {
              // pickImage(ImageSource.gallery, widget.token,
              //     widget.userId, widget.vehicleId.toString());
              checkStoragePermission(widget.vehicleId.toString());
              Get.back();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.photo_library, size: 30),
                SizedBox(height: 4),
                Text('Gallery')
              ],
            ),
          )
        ],
      ),
    );
  }
}

class VehicleEditController extends GetxController {
  var vehicleTypeId = '0'.obs;
  var vehicleBrandId = '0'.obs;
  var vehicleModelId = '0'.obs;
  var vehicleVariantId = '0'.obs;

  var vehicleYear = ''.obs;
  var vehicleEndYear = ''.obs;
  var vehicleCC = ''.obs;
}
