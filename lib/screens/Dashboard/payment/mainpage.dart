import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  var currentStep = 0;
  Widget? child;

  Box? box1;

  @override
  void initState() {
    super.initState();

    createBox();
    productController.paymentType.value = 0;
  }

  void createBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {});
  }

  ProductOrderController productController = Get.put(ProductOrderController());
  final PaymentController paymentController = Get.put(PaymentController());

  APIService service = APIService();

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
        isActive: currentStep >= 0,
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        content: CheckOutPage(),
        title: const Text("CheckOut"),
      ),
      Step(
        title: const Text("payment"),
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        content: const PaymentPage(),
        isActive: currentStep >= 1,
      ),
      Step(
        title: const Text("order"),
        content: const OrderDetailsPage(),
        isActive: currentStep >= 2,
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
    ];
    return GetScaffold(
      title: "CheckOut",
      body: box1?.get("data4") == null
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : Theme(
              data: ThemeData(
                primarySwatch: Colors.red,
                colorScheme: currentStep >= 0
                    ? const ColorScheme.light(primary: kPrimaryColor)
                    : const ColorScheme.light(primary: Colors.green),
              ),
              child: Stepper(
                  currentStep: currentStep,
                  steps: steps,
                  type: StepperType.horizontal,
                  onStepContinue: () {
                    final islaststep = currentStep == steps.length - 1;
                    if (islaststep) {
                      debugPrint("completed");
                      Get.off(() => Dashboard());
                   
                      productController.paymentType.value = 0;
                    } else {
                      if (currentStep == 0) {
                        setState(() {
                          currentStep += 1;
                        });
                      }

                      if (currentStep == 1) {
                       
                        if (productController.paymentType.value == 0) {
                          return null;
                        }
                        if (productController.paymentType.value == 1) {
                          var initPayment = service.onlinePaymentInitiateApi(
                              token: box1?.get("data4"),
                              userId: box1?.get("data3"));
                          initPayment.then((value) {
                            if (value!.success == "1") {
                              paymentController.goTransactionId.value =
                                  value.orders.gologixTranctionid.toString();
                              paymentController.orderId.value =
                                  value.orders.orderid.toString();
                            }

                            paymentController.dispatchPayment(
                              (productController.checkoutTotal.value * 100),
                              'Gologix Solution Private ltd.',
                              box1?.get('data1'),
                              "products",
                              box1?.get('data2'),
                              'Paytm'
                            );
                            PaymentStatusController paymentStatusController=Get.put(PaymentStatusController());


                            if(paymentStatusController.paymentcontrollerstatus.value==1){
                              setState(() {
                            currentStep += 1;
                          });
                              

                            }
                            setState(() {});

                            // productController..value == 1?currentStep += 1:null;
                          });
                        }
                        if (productController.paymentType.value == 2) {
                          setState(() {
                            currentStep += 1;
                          });
                        }
                      }
                    }
                  },
                  onStepCancel: currentStep == 0
                      ? null
                      : () {
                          setState(() {
                            currentStep -= 1;
                          });
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
                          child: const Text("Continue",
                              style: TextStyle(color: Colors.white)),
                          onPressed: details.onStepContinue,
                        ),
                      ),
                    );
                  }),
            ),
    );
  }
}

