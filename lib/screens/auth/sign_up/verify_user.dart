import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/screens/auth/login/signin.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/auth/ClipWidget.dart';
import 'package:bike_cafe/widget/auth/txt_formfield.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/models/auth/signIn_model.dart';

class VerifyUser extends StatefulWidget {
  VerifyUser(
      {Key? key,
      this.userId,
      this.phoneNumber,
      this.userName,
      this.userEmail,
      this.userPassword,
      this.confirmPassword,
      this.smsId})
      : super(key: key);

  String? userId;
  String? phoneNumber;
  String? userName;
  String? userEmail;
  String? userPassword;
  String? confirmPassword;
  String? smsId;

  @override
  _VerifyUserState createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  APIService apiService = APIService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _otpController = TextEditingController();
  SignInRequestModel? requestModel1 = new SignInRequestModel();

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      try {
        var verify = apiService.verifyUserByOtpToRegisterApi(
            otpId: widget.smsId, userOtp: _otpController.text.toString());
        verify.then((value) {
          if (value!.success == 1) {
            _register();
          } else {
            Get.snackbar('Failed..', value.message.toString(),
                snackPosition: SnackPosition.TOP,
                duration: Duration(seconds: 5),
                backgroundColor: Colors.white,
                colorText: Colors.red);
          }
        });
      } catch (e) {
        print(e.toString());
      }
      return true;
    }
    return false;
  }

  _register() {
    try {
      var register = apiService.signUp(
          requestModel1: requestModel1!,
          apiUrl1: "api/v1/accounts/register",
          name: widget.userName.toString(),
          email: widget.userEmail.toString(),
          password: widget.userPassword.toString(),
          number: widget.phoneNumber.toString(),
          confrmpass: widget.confirmPassword.toString());

      register.then((value) {
        if (value!.success == 1) {
          Get.off(() => SignIn());
        } else {
          Get.snackbar('Failed..', value.message.toString(),
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 5),
              backgroundColor: Colors.white,
              colorText: Colors.red);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextWidgetStyle style = TextWidgetStyle();
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: clipWidget(
                    title: "OTP",
                    subtitle: "Verification",
                  ),
                  height: 200,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: Config.Height * 0.15),
                      const Text('Enter OTP sent your mobile number'),
                      const SizedBox(height: 10),
                      Text('+91 ' + widget.phoneNumber.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: RoundedTextFormField(
                          controller: _otpController,
                          hintText: 'Enter OTP',
                          type: TextInputType.number,
                          textAlign: TextAlign.center,
                          validator: (input) {
                            bool _isNumberValid =
                                RegExp(r"^[0-9]{6}").hasMatch(input!);
                            if (input == '') {
                              return 'Enter OTP';
                            } else if (!_isNumberValid) {
                              return 'Invalid OTP';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: TextButton(
                              child: style.Roboto(
                                  text: "Resend OTP",
                                  fontwight: FontWeight.w400,
                                  size: 16,
                                  color: Colors.black),
                              onPressed: () {},
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: FloatingActionButton(
                              backgroundColor: kPrimaryColor,
                              onPressed: () {
                                validateAndSave();
                              },
                              child: Icon(Icons.arrow_right_alt_outlined),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
