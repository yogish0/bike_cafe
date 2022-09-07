import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/controllers/bottombarcontroller.dart';
import 'package:bike_cafe/controllers/paymentcontroller.dart';
import 'package:bike_cafe/controllers/paymentstatuscontroller.dart';
import 'package:bike_cafe/screens/Dashboard/Home/dashboard.dart';
import 'package:bike_cafe/screens/Dashboard/payment/locale/checkout.dart';
import 'package:bike_cafe/screens/Dashboard/payment/locale/orderdetails.dart';
import 'package:bike_cafe/screens/Dashboard/payment/locale/payment.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';
import 'package:hive/hive.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget? child;

  Box? box1;
  PaymentStatusController controller = Get.put(PaymentStatusController());

  @override
  void initState() {
    super.initState();
    controller.currentStep.value = 0;
    controller.paymentmethod.value = 0;
    controller.codpaymentresponse.value = 0;
    controller.coninuelodaing.value = false;

    createBox();
  }

  void createBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {});
  }

  final PaymentController paymentController = Get.put(PaymentController());

  APIService service = APIService();

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
        isActive: controller.currentStep >= 0,
        state:
            controller.currentStep > 0 ? StepState.complete : StepState.indexed,
        content: CheckOutPage(),
        title: const Text("CheckOut"),
      ),
      Step(
        title: const Text("payment"),
        state:
            controller.currentStep > 1 ? StepState.complete : StepState.indexed,
        content: const PaymentPage(),
        isActive: controller.currentStep >= 1,
      ),
      Step(
        title: const Text("order"),
        content: OrderDetailsPage(),
        isActive: controller.currentStep >= 2,
        state:
            controller.currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
    ];
    return GetScaffold(
      title: "CheckOut",
      index: 6,
      body: Theme(
        data: ThemeData(
          primarySwatch: Colors.red,
          colorScheme: controller.currentStep >= 0
              ? const ColorScheme.light(primary: kPrimaryColor)
              : const ColorScheme.light(primary: Colors.green),
        ),
        child: Obx(() => Stepper(
            currentStep: controller.currentStep.toInt(),
            steps: [
              Step(
                isActive: controller.currentStep >= 0,
                state: controller.currentStep > 0
                    ? StepState.complete
                    : StepState.indexed,
                content: CheckOutPage(),
                title: const Text("CheckOut"),
              ),
              Step(
                title: const Text("payment"),
                state: controller.currentStep > 1
                    ? StepState.complete
                    : StepState.indexed,
                content: controller.coninuelodaing.value == true
                    ? Container(
                        height: 300,
                        width: 250,
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.red),
                        ),
                      )
                    : PaymentPage(),
                isActive: controller.currentStep >= 1,
              ),
              Step(
                title: const Text("order"),
                content: OrderDetailsPage(),
                isActive: controller.currentStep >= 2,
                state: controller.currentStep > 2
                    ? StepState.complete
                    : StepState.indexed,
              ),
            ],
            type: StepperType.horizontal,
            onStepContinue: () {
              final islaststep = controller.currentStep == steps.length - 1;
              if (islaststep) {
                debugPrint("completed");
                Get.off(() => Dashboard());
                BottomNavigationController bottomcontroller =
                    BottomNavigationController();
              } else {
                if (controller.currentStep == 0) {
                  controller.currentStep.value += 1;
                }
                if (controller.currentStep == 1) {
                  debugPrint(controller.paymentmethod.value.toString());

                  if (controller.paymentmethod.value == 1) {
                    paymentController.dispatchPayment(
                        (controller.grandtotal.value.round() * 100),
                        'Gologix Solution Private ltd.',
                        box1?.get('data1'),
                        "products",
                        box1?.get('data2'),
                        'Paytm');
                  } else if (controller.paymentmethod.value == 2) {
                    controller.coninuelodaing.value = true;
                    service.codPaymentOrderApi(
                        token: box1?.get("data4"), userId: box1?.get("data3"));
                  }
                } else {
                  controller.currentStep == 2;
                }
              }
            },
            onStepCancel: controller.currentStep == 0
                ? null
                : () {
                    // setState(() {
                    //   currentStep -= 1;
                    // });
                    controller.currentStep.value = 0;
                  },
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 8, right: 12),
                  width: Config.Width * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: kPrimaryColor),
                  child: TextButton(
                    child:
                        Text("Continue", style: TextStyle(color: Colors.white)),
                    onPressed: details.onStepContinue,
                  ),
                ),
              );
            })),
      ),
    );
  }
}
