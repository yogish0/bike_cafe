import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/controllers/authcontroller.dart';
import 'package:bike_cafe/models/auth/login_model.dart';

// import 'package:bike_cafe/screens/Dashboard/dashboard.dart';
import 'package:bike_cafe/screens/SlidingScreen/RegisterVehicle.dart';
import 'package:bike_cafe/services/api.dart';

import 'package:bike_cafe/widget/auth/button.dart';

import 'package:bike_cafe/widget/auth/txt_formfield.dart';
import 'package:bike_cafe/widget/config.dart';
// import 'package:pinput/pin_put/pin_put.dart';

class Opt_form extends StatefulWidget {
  Opt_form({Key? key}) : super(key: key);

  @override
  State<Opt_form> createState() => _Opt_formState();
}

class _Opt_formState extends State<Opt_form> {
  var isSignedIn = false.obs;
  final _formKey = GlobalKey<FormState>();
  bool? isApiCallProcess = false;

  LoginRequestModel? requestModel;

  TextEditingController _passwordController = TextEditingController();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: kPrimaryColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    TextEditingController _mobileController = TextEditingController();
    final FocusNode _pinPutFocusNode = FocusNode();
    final TextEditingController _pinPutController = TextEditingController();

    String? verificationId;

    final _authController = Get.find<AuthController>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          RoundedTextFormField(
            hintText: 'Phone Number',
            type: TextInputType.number,
            controller: _mobileController,
          ),
          // Obx(() {
          //   return _authController.code_sent_result == "yes"
          //       ? Column(children: [
          //           SizedBox(height: Config.screenHeight! * 0.03),
          //           PinPut(
          //             fieldsCount: 6,
          //             onSubmit: (String pin) {},
          //             focusNode: _pinPutFocusNode,
          //             controller: _pinPutController,
          //             submittedFieldDecoration: _pinPutDecoration.copyWith(
          //               borderRadius: BorderRadius.circular(20.0),
          //             ),
          //             selectedFieldDecoration: _pinPutDecoration,
          //             followingFieldDecoration: _pinPutDecoration.copyWith(
          //               borderRadius: BorderRadius.circular(5.0),
          //               border: Border.all(
          //                 color: kPrimaryColor.withOpacity(.5),
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             height: 30,
          //           ),
          //         ])
          //       : Text("waiting to verify");
          // }),
          SizedBox(height: Config.Height * 0.03),
          RoundedElevatedButton(
            title: 'Send Otp',
            onPressed: () {},
            padding: EdgeInsets.symmetric(
                horizontal: Config.Height * 0.32,
                vertical: Config.Height * 0.02),
          ),
        ],
      ),
    );
  }
}
