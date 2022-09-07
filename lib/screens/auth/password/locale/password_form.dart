import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/screens/auth/login/signin.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/auth/txt_formfield.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/constrants.dart';

import 'forgot_password_otp.dart';

class ResetForm extends StatefulWidget {
  const ResetForm({
    Key? key,
  }) : super(key: key);

  @override
  State<ResetForm> createState() => _ResetFormState();
}

class _ResetFormState extends State<ResetForm> {
  APIService apiService = APIService();

  final _formKey = GlobalKey<FormState>();
  TextEditingController _mobileController = TextEditingController();

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      try {
        apiService
            .forgotPasswordOtpApi(
                phoneNumber: _mobileController.text.toString())
            .then((value) {
          if (value?.userid != null) {
            Get.to(() => ForgotPasswordOtp(
                userId: value?.userid.toString(),
                phoneNumber: _mobileController.text.toString()));
          }
        });
      } catch (e) {
        debugPrint(e.toString());
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text('Enter registered mobile number'),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: RoundedTextFormField(
              hintText: 'Mobile Number',
              controller: _mobileController,
              type: TextInputType.number,
              validator: (value) {
                bool _isnumberValid =
                    RegExp(r"^[6-9][0-9]{9}").hasMatch(value!);
                if (value == '') {
                  return 'Enter Mobile Number';
                } else if (!_isnumberValid) {
                  return 'Invalid Number.';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: Config.Height * 0.05),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    child: Constants.linkText("Sign In"),
                    onPressed: () => Get.to(() => const SignIn()),
                  ),
                ),
                const Spacer(),
                FloatingActionButton(
                  backgroundColor: kPrimaryColor,
                  onPressed: () {
                    validateAndSave();
                  },
                  child: const Icon(Icons.arrow_right_alt_outlined),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
