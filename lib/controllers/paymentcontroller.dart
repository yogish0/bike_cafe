import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bike_cafe/controllers/paymentstatuscontroller.dart';
import 'package:bike_cafe/models/Order_Model/payment_failed_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentController extends GetxController {

  late Razorpay razorpay;
  var payment_id = ''.obs;

  //payment initiate response to verify payment
  var goTransactionId = ''.obs;
  var orderId = ''.obs;

  var failedPaymentId = ''.obs;
  var paymentStatus = 0.obs;


 
  //if paymentStatus = 1, payment success
  //if paymentStatus = 2, payment failed

  @override
  void onInit() {
    super.onInit();
    razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async{
    // Get.snackbar(
    //     'Payment Successful!',
    //     response.orderId.toString() +
    //         " \n" +
    //         response.paymentId.toString() +
    //         "\n" +
    //         response.signature.toString());

PaymentStatusController paymentStatusController=Get.put(PaymentStatusController());

paymentStatusController.paymentcontrollerstatus.value=1;

    Get.snackbar(
      'Payment Successful!', "Payment id : " + response.paymentId.toString(),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.8),
        colorText: Colors.white
    );

    

    payment_id.value = response.paymentId.toString();
    debugPrint('payment id : '+payment_id.value);
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async{
    var failedResponse = PaymentCancelledResponseModel.fromMap(jsonDecode(response.message.toString()));
    // Get.snackbar('Payment Error Occurred', response.message.toString());

    failedPaymentId.value = failedResponse.error.metadata.paymentId.toString();
    debugPrint(failedResponse.error.metadata.paymentId.toString());
    debugPrint(response.message.toString());
    debugPrint(response.code.toString());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar('External Wallet Successful!', response.walletName.toString());
  }

  Future<void> dispatchPayment(int amount, String name, String contact,
      String description, String email, String wallet) async{
    var options = {
      'key': 'rzp_test_0CUClQS9ymJpN7',
      'amount': amount, //in the smallest currency sub-unit.
      'name': name,
      'description': description,
      // 'timeout': 60, // in seconds
      'retry': {'enabled': true, 'max_count': 2},
      'prefill': {'contact': contact, 'email': email},
      'external': {
        'wallets': [wallet]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
