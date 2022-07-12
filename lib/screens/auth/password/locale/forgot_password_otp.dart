import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/screens/auth/login/signin.dart';
import 'package:bike_cafe/screens/auth/password/locale/reset_password.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/auth/ClipWidget.dart';
import 'package:bike_cafe/widget/auth/txt_formfield.dart';
import 'package:bike_cafe/widget/config.dart';

class ForgotPasswordOtp extends StatefulWidget {
  ForgotPasswordOtp({Key? key, this.userId, this.phoneNumber}) : super(key: key);

  String? userId;
  String? phoneNumber;

  @override
  _ForgotPasswordOtpState createState() => _ForgotPasswordOtpState();
}

class _ForgotPasswordOtpState extends State<ForgotPasswordOtp> {
  APIService apiService = APIService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _otpController = TextEditingController();
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      try{
        var verify = apiService.verifyUserByOtpApi(userId: widget.userId, userOtp: _otpController.text.toString());
        verify.then((value){
          if(value!.success == 1){
            Get.off(()=> PasswordReset(userId: widget.userId.toString()));
          }else{
            Fluttertoast.showToast(msg: value.message.toString());
          }
        });
      }catch(e){
        print(e.toString());
      }
      return true;
    }
    return false;
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
                      Text('+91 '+ widget.phoneNumber.toString(),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: RoundedTextFormField(
                          controller: _otpController,
                          hintText: 'Enter OTP',
                          type: TextInputType.number,
                          textAlign: TextAlign.center,
                          validator: (input) {
                            bool _isNumberValid = RegExp(r"^[0-9]{6}").hasMatch(input!);
                            if(input == ''){
                              return 'Enter OTP';
                            }else if (!_isNumberValid) {
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
