import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/controllers/imageController.dart';
import 'package:bike_cafe/controllers/vechileListController.dart';
import 'package:bike_cafe/models/Vechile/getvechiclebyuserid.dart';
import 'package:bike_cafe/screens/SlidingScreen/eidtVechile/editvechile.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:image_picker/image_picker.dart';

import '../../../main.dart';

class VechileProfile extends StatefulWidget {
  VechileProfile({Key? key}) : super(key: key);

  @override
  State<VechileProfile> createState() => _VechileProfileState();
}

class _VechileProfileState extends State<VechileProfile> {
  APIService service = APIService();

  // final _vechileListController = Get.find<VehicleController>();

  @override
  Widget build(BuildContext context) {
    return Column(children: []);
  }
}

//  Padding(
//           padding: const EdgeInsets.only(top: 10, bottom: 10),
//           child: Container(
//             height: 150,
//             width: 170,
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image:
//                         FileImage(File(_imageController.selectImagePath.value)),
//                     fit: BoxFit.cover)),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 4),
//               child: Align(
//                 alignment: Alignment.bottomRight,
//                 child: IconButton(
//                   color: kPrimaryColor,
//                   icon: Icon(Icons.camera_alt),
//                   onPressed: () {
//                     _imageController.getImage(ImageSource.camera);
//                   },
//                 ),
//               ),
//             ),

//             // Padding(
//             //   padding: const EdgeInsets.only(top: 10),
//             //   child: Column(

//             //     children: [
            // Obx(() => _imageController.selectImagePath.value == ''
            //     ? IconButton(
            //         onPressed: () {
            //           _imageController.getImage(ImageSource.gallery);
            //         },
            //         icon: Icon(
            //           Icons.photo_album,
            //           size: 50,
            //         ))
            //     : Container(
            //         color: Colors.amber,
            //         child: Image.file(
            //           File(_imageController.selectImagePath.value),
            //           width: MediaQuery.of(context).size.width,
            //           height: 90,
            //         ),
            //       )),

//             // ]),
//           ),
//         ),

//  Container(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: Config.Height * 0.01),
//               Text(
//                 "Brand:",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 "Model:",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 "CC:",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 "Year:",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 0, left: 30),
//                 child: Row(
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           Get.to(() => EditVeichle());
//                         },
//                         icon: Icon(
//                           Icons.edit,
//                           size: 20,
//                         )),
//                     IconButton(
//                         onPressed: () {},
//                         icon: Icon(
//                           Icons.delete_sweep,
//                           size: 20,
//                         )),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
