import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/models/Vechile/getvechiclebyuserid.dart';
import 'package:bike_cafe/screens/Dashboard/Home/dashboard.dart';
import 'package:bike_cafe/screens/Dashboard/profile/locale/gallery_widget.dart';
import 'package:bike_cafe/screens/SlidingScreen/eidtVechile/editvechile.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/auth/vector.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../main.dart';
import '../RegisterVehicle.dart';

class ListedVehicle extends StatefulWidget {
  ListedVehicle({Key? key}) : super(key: key);

  @override
  State<ListedVehicle> createState() => _ListedVehicleState();
}

class _ListedVehicleState extends State<ListedVehicle> {
  APIService service = APIService();

  final height = Get.height;
  final width = Get.width;

  File? image;
  final picker = ImagePicker();

  //pick image from gallery/camera
  Future pickImage(ImageSource imgSource, String token, String userId,
      String vehicleId) async {
    final PickedFile =
        await picker.pickImage(source: imgSource, imageQuality: 50);
    if (PickedFile != null) {
      image = File(PickedFile.path);
      if (image != null) {
        service
            .vehicleImageUploadApi(
                token: token, userId: userId, vehicleId: vehicleId, img: image!)
            .then((value) {
          setState(() {});
        });
      }
      setState(() {});
    } else {
      debugPrint('no image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: box1.get("data4") == null
            ? const Center()
            : Column(
                // physics: const ScrollPhysics(),
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  appbartheme(),
                  Container(
                    height: height * 0.65,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: FutureBuilder<GetVechiclebyuserid?>(
                      future: service.getvechiledetailsbyuserid(
                          token: box1.get("data4"),
                          id: box1.get("data3").toString()),
                      builder: (context,
                          AsyncSnapshot<GetVechiclebyuserid?> snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {}
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          if (snapshot.data!.body.isEmpty) {
                            return SizedBox(
                              height: height * 0.65,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Center(
                                    child: Text(
                                        'You are not added any vehicles yet'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.to(() => const RegisterVehicle());
                                    },
                                    child: const Text("+ Add Vehicles",
                                        style: TextStyle(color: Colors.red)),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data!.body.length,
                              itemBuilder: (context, index) {
                                // debugPrint(snapshot.data!.body[index].variantName);
                                var vechile = snapshot.data!.body[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 4,
                                    child: Container(
                                      width: width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Row(
                                        children: [
                                          imgContainer(vechile),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 4),
                                                  RichText(
                                                    text: TextSpan(
                                                      // style: DefaultTextStyle.of(context).style,
                                                      children: <TextSpan>[
                                                        const TextSpan(
                                                            text: 'Brand: ',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text: vechile
                                                                .variantName
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black)),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  RichText(
                                                    text: TextSpan(
                                                      // style: DefaultTextStyle.of(context).style,
                                                      children: <TextSpan>[
                                                        const TextSpan(
                                                            text: 'Model: ',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text: vechile
                                                                .modelName
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black)),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  RichText(
                                                    text: TextSpan(
                                                      // style: DefaultTextStyle.of(context).style,
                                                      children: <TextSpan>[
                                                        const TextSpan(
                                                            text: 'CC: ',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text: vechile.cc
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black)),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      RichText(
                                                        text: const TextSpan(
                                                          // style: DefaultTextStyle.of(context).style,
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: 'Year: ',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          // style: DefaultTextStyle.of(context).style,
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: vechile
                                                                    .launchYear
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black)),
                                                            if (vechile.endYear
                                                                    .toString() !=
                                                                "null")
                                                              TextSpan(
                                                                  text: ' - ' +
                                                                      vechile
                                                                          .endYear
                                                                          .toString(),
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .black))
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if (vechile
                                                          .usevehVehicleNumber !=
                                                      null)
                                                    RichText(
                                                      text: TextSpan(
                                                        // style: DefaultTextStyle.of(context).style,
                                                        children: <TextSpan>[
                                                          const TextSpan(
                                                              text:
                                                                  'Vehicle number : ',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          TextSpan(
                                                              text: vechile
                                                                  .usevehVehicleNumber
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .black)),
                                                        ],
                                                      ),
                                                    ),
                                                  // Text(
                                                  //   vechile.variantName.toString(),
                                                  //   // maxLines: 2,
                                                  //   overflow: TextOverflow.ellipsis,
                                                  // ),
                                                  Row(
                                                    children: [
                                                      const Spacer(),
                                                      InkWell(
                                                        onTap: () {
                                                          Get.to(
                                                              () => EditVeichle(
                                                                    token: box1
                                                                        .get(
                                                                            "data4")
                                                                        .toString(),
                                                                    userId: box1
                                                                        .get(
                                                                            "data3")
                                                                        .toString(),
                                                                    vehicleId: vechile
                                                                        .usevehRegId
                                                                        .toString(),
                                                                  ));
                                                        },
                                                        child: const SizedBox(
                                                          width: 40,
                                                          height: 30,
                                                          child: Icon(Icons
                                                              .edit_outlined),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          Get.defaultDialog(
                                                              content: Text('Do you want to remove ' +
                                                                  vechile
                                                                      .variantName
                                                                      .toString() +
                                                                  ' from vehicles list'),
                                                              radius: 5,
                                                              onCancel: () {},
                                                              onConfirm: () {
                                                                var deleteVehicle = service.deleteVehicleById(
                                                                    token: box1.get(
                                                                        "data4"),
                                                                    userId: box1
                                                                        .get(
                                                                            "data3")
                                                                        .toString(),
                                                                    vehicleId: vechile
                                                                        .usevehRegId
                                                                        .toString());
                                                                deleteVehicle
                                                                    .then(
                                                                        (value) {
                                                                  setState(
                                                                      () {});
                                                                  Get.back();
                                                                });
                                                              },
                                                              textConfirm:
                                                                  'Confirm',
                                                              buttonColor:
                                                                  kPrimaryColor,
                                                              cancelTextColor:
                                                                  kPrimaryColor,
                                                              confirmTextColor:
                                                                  Colors.white);
                                                        },
                                                        child: const SizedBox(
                                                          width: 40,
                                                          height: 30,
                                                          child: Icon(Icons
                                                              .delete_outline),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 6)
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        width: 110,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Get.to(() => const RegisterVehicle());
                            },
                            child: const Text(
                              '+ Add',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: TextButton(
                          child: const Text(
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
                    ],
                  )
                ],
              ),
      ),
    );
  }

  Widget imgContainer(Body vechile) {
    var imageList = [
      // "https://msilonline.in" + vechile.vehicleImage.toString(),
      "https://bikecafe.co.in" + vechile.vehicleImage.toString(),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: SizedBox(
        height: 120,
        width: 150,
        child: Stack(
          children: [
            vechile.vehicleImage == null
                ? const SizedBox(
                    height: 120, width: 150, child: Icon(Icons.image, size: 50))
                : Center(
                    child: InkWell(
                    onTap: () {
                      Get.to(() => GalleryWidget(urlImages: imageList));
                    },
                    child: Image.network(
                        // "https://msilonline.in" + vechile.vehicleImage.toString(),
                        "https://bikecafe.co.in" +
                            vechile.vehicleImage.toString(),
                        width: 130),
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
                      builder: (context) => uploadOptions(vechile),
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

  bool cameraPermission = false;
  bool storagePermission = false;

  //ask permission for camera
  void checkCameraPermission(String vehicleId) async {
    if (await Permission.camera.request().isGranted) {
      setState(() {
        cameraPermission = true;
      });
      pickImage(ImageSource.camera, box1.get('data4'), box1.get('data3'),
          vehicleId.toString());
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
  void checkStoragePermission(String vehicleId) async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        storagePermission = true;
      });
      pickImage(ImageSource.gallery, box1.get('data4'), box1.get('data3'),
          vehicleId.toString());
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
  Widget uploadOptions(Body vechile) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              // pickImage(ImageSource.camera, box1.get('data4'),
              //     box1.get('data3'), vechile.usevehRegId.toString());
              checkCameraPermission(vechile.usevehRegId.toString());
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
              // pickImage(ImageSource.gallery, box1.get('data4'),
              //     box1.get('data3'), vechile.usevehRegId.toString());
              checkStoragePermission(vechile.usevehRegId.toString());
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

Widget appbartheme() {
  return Row(
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
              icon: const Icon(Icons.chevron_left_sharp,
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
  );
}
