import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/instance_manager.dart';
import 'package:bike_cafe/controllers/authcontroller.dart';
import 'package:bike_cafe/controllers/homeController.dart';
import 'package:bike_cafe/controllers/imageController.dart';
import 'package:bike_cafe/controllers/notificationcontroller.dart';
import 'package:bike_cafe/controllers/vechileListController.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
    Get.put<ImageController>(ImageController());
    Get.put<VehicleController>(VehicleController());
    // Get.put<NotificationController>(NotificationController());
  }
}
