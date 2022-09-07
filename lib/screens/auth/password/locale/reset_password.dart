import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/screens/auth/login/signin.dart';
import 'package:bike_cafe/screens/auth/sign_up/sign_up.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/auth/ClipWidget.dart';
import 'package:bike_cafe/widget/auth/txt_formfield.dart';
import 'package:bike_cafe/widget/config.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key, required this.userId}) : super(key: key);

  final String? userId;

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  APIService apiService = APIService();

  final _formKey = GlobalKey<FormState>();
  TextWidgetStyle style = TextWidgetStyle();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confrmpasswordController = TextEditingController();

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      try {
        var resetResponse = apiService.resetPasswordApi(
            userId: widget.userId.toString(),
            password: _passwordController.text.toString());
        resetResponse.then((value) {
          if (value?.success == 1) {
            Get.off(() => SignIn());
          }
        });
      } catch (e) {
        print(e.toString());
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                child: clipWidget(
                  title: "Reset",
                  subtitle: "Password",
                ),
                height: 200,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: Config.Height * 0.15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: RoundedPassWordTextFormField(
                        controller: _passwordController,
                        hintText: 'New Password',
                        validator: (input) {
                          if (input.toString().length < 8) {
                            return 'Password should be longer or equal to 8 characters.';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: Config.Height * 0.01),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: RoundedPassWordTextFormField(
                        controller: _confrmpasswordController,
                        hintText: 'Confirm Password',
                        validator: (input) {
                          if (input.trim() != _passwordController.text.trim()) {
                            return 'Passwords does not match!';
                          }

                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: Config.Height * 0.01),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Spacer(),
                          FloatingActionButton(
                            backgroundColor: kPrimaryColor,
                            onPressed: () {
                              validateAndSave();
                            },
                            child: Icon(Icons.arrow_right_alt_outlined),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Config.Height * 0.05),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          TextButton(
                            child: style.Roboto(
                                text: "Sign Up",
                                fontwight: FontWeight.w400,
                                size: 18,
                                color: Colors.black),
                            onPressed: () => Get.to(() => SignUp()),
                          ),
                          Spacer(),
                          TextButton(
                            child: style.Roboto(
                                text: "Sign In",
                                fontwight: FontWeight.w400,
                                size: 18,
                                color: Colors.black),
                            onPressed: () => Get.to(() => SignIn()),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
