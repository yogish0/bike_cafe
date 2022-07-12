// ignore: file_names
import 'dart:io';

import 'package:get/get.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  var selectImagePath = ''.obs;
  var selectedImageSize = ''.obs;
// Future<bool> checkAndRequestCameraPermissions() async {
//   PermissionStatus permission =
//       await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
//   if (permission != PermissionStatus.granted) {
//     Map<PermissionGroup, PermissionStatus> permissions =
//         await PermissionHandler().requestPermissions([PermissionGroup.camera]);
//     return permissions[PermissionGroup.camera] == PermissionStatus.granted;
//   } else {
//     return true;
//   }
// }
  void getImage(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      selectImagePath.value = pickedFile.path;
      selectedImageSize.value =
          ((File(selectImagePath.value)).lengthSync() / 1024 / 1024)
                  .toStringAsFixed(2) +
              "MB";
    } else {
      Get.snackbar("Error", "No Image Selected",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: kPrimaryColor,
          colorText: kBackgroundColor);
    }
  }
}
