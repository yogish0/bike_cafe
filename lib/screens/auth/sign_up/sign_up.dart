import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/models/auth/signIn_model.dart';
import 'package:bike_cafe/screens/auth/login/signin.dart';
import 'package:bike_cafe/screens/auth/sign_up/verify_user.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/auth/ClipWidget.dart';
import 'package:bike_cafe/widget/auth/txt_formfield.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/constrants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import '../../Dashboard/Home/dashboard.dart';
import '../../SlidingScreen/RegisterVehicle.dart';
import 'google_authentication.dart';
import 'locale/facebook_authentication.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'locale/social_auth_mobile_verification.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confrmpasswordController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  SignInRequestModel? requestModel1;

  // final users = FirebaseAuth.instance.currentUser;
  TextWidgetStyle style = TextWidgetStyle();

  bool? isApiCallProcess = false;

  //user device id
  String androidId = '';

  Box? box1;

  @override
  void initState() {
    super.initState();
    requestModel1 = SignInRequestModel();

    createBox();

    //fetching user device id
    DeviceInfoApi.getDeviceAndroidId().then((String value) {
      setState(() {
        androidId = value;
      });
      debugPrint("android id : " + androidId);
    });

    if (FirebaseAuth.instance.currentUser != null) {
      googleAuthentication.logOut();
    }
  }

  void createBox() async {
    box1 = await Hive.openBox('logindata');
  }

  GoogleAuthentication googleAuthentication = GoogleAuthentication();
  FacebookAuthentication facebookAuthentication = FacebookAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        bottom: true,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: SizedBox(
                  child: clipWidget(
                    title: "Create",
                    subtitle: "Account",
                  ),
                  height: 200,
                ),
              ),
              SizedBox(height: Config.Height * 0.02),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: buildTextFormFields(),
              ),
              SizedBox(height: Config.Height * 0.02),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: style.Monterserrat(
                        text: "Sign Up",
                        fontwight: FontWeight.w600,
                        size: 30,
                        color: Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: FloatingActionButton(
                      backgroundColor: kPrimaryColor,
                      onPressed: () {
                        validateAndSave();
                      },
                      child: const Icon(Icons.arrow_right_alt_outlined),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Config.Height * 0.02),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const SizedBox(width: 30),
                  // Row(
                  //   children: [
                  //     const SizedBox(width: 8),
                  //     Text(
                  //       "Sign with",
                  //       style: TextStyle(
                  //         color: Colors.black,
                  //         fontWeight: FontWeight.w400,
                  //         fontSize: 18,
                  //         fontFamily: GoogleFonts.roboto().fontFamily
                  //       ),
                  //     ),
                  //     SignInButton.mini(
                  //       buttonType: ButtonType.google,
                  //       padding: 2,
                  //       onPressed: () {
                  //         try {
                  //           googleAuthentication.googleSignIn().then((value) {
                  //             var googleUserData =
                  //                 FirebaseAuth.instance.currentUser;
                  //             print(googleUserData?.email!.toString());
                  //             print("-------");
                  //             print(googleUserData?.uid.toString());
                  //             print(googleUserData?.displayName.toString());
                  //             apiService
                  //                 .checkSocialAuthUserApi(
                  //                     email:
                  //                         googleUserData?.email!.toString())
                  //                 .then((value) {
                  //               if (value!.isavailable == "1") {
                  //                 apiService
                  //                     .socialAuthUserApi(
                  //                         email: googleUserData?.email!,
                  //                         userName:
                  //                             googleUserData?.displayName!,
                  //                         deviceToken:
                  //                             box1!.get("device_token"),
                  //                         mailIdToken: googleUserData?.uid,
                  //                         androidId: androidId,
                  //                         authType: "email",
                  //                         phoneNumber: null)
                  //                     .then((value) {
                  //                   if (value!.apiToken != "null") {
                  //                     box1!.put('data0',
                  //                         value.user!.name.toString());
                  //                     box1!.put('data1',
                  //                         value.user!.phonenumber.toString());
                  //                     box1!.put('data2',
                  //                         value.user!.email.toString());
                  //                     box1!.put(
                  //                         'data3', value.user!.id.toString());
                  //                     box1!.put(
                  //                         'data4', value.apiToken.toString());
                  //                     box1!.put('isLogged', true);
                  //                     box1!.put("welcomeNotification", false);
                  //                     box1!.put("isGoogleAuth", true);
                  //                     var checkVehicleList = apiService
                  //                         .getvechiledetailsbyuserid(
                  //                             token:
                  //                                 value.apiToken.toString(),
                  //                             id: value.user!.id.toString());
                  //                     checkVehicleList?.then((value) {
                  //                       value!.body.isEmpty
                  //                           ? Get.off(
                  //                               () => const RegisterVehicle())
                  //                           : Get.off(() => Dashboard());
                  //                     });
                  //                   } else {
                  //                     Fluttertoast.showToast(
                  //                         msg: "Sign up failed");
                  //                     googleAuthentication.logOut();
                  //                   }
                  //                 });
                  //               } else {
                  //                 Get.to(() => SocialAuthMobileVerification(
                  //                     email: googleUserData?.email!,
                  //                     userName: googleUserData?.displayName!,
                  //                     deviceToken: androidId,
                  //                     mailIdToken: googleUserData?.uid,
                  //                     authType: "email"));
                  //               }
                  //             });
                  //           });
                  //         } catch (e) {
                  //           debugPrint(e.toString());
                  //         }
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // // SignInButton.mini(
                  // //   buttonType: ButtonType.facebook,
                  // //   onPressed: () async{
                  // //     facebookAuthentication.facebookLogin().then((value) {
                  // //           var fbUserData = FirebaseAuth.instance.currentUser;
                  // //           debugPrint(fbUserData?.email.toString());
                  // //           debugPrint(fbUserData?.displayName.toString());
                  // //           debugPrint(fbUserData?.uid.toString());
                  // //         });
                  // //   },
                  // // ),
                  // const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Row(
                      children: [
                        style.Roboto(
                            text: "I have account! ",
                            fontwight: FontWeight.w400,
                            color: Colors.black),
                        TextButton(
                          child: Constants.linkText("Sign In"),
                          onPressed: () => Get.to(() => const SignIn()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // SizedBox(height: Config.screenHeight! * 0.08),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: style.Roboto(
                    text:
                        "By proceeding , I will accept terms, conditions and privacy policies",
                    fontwight: FontWeight.w400,
                    size: 12,
                    color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }

  APIService apiService = APIService();

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      // _register();
      form.save();
      try {
        var sendOtp = apiService.OtpToMobileNumberVerify(
            phoneNumber: _phoneController.text.toString());
        sendOtp.then((value) {
          if (value!.success == 1) {
            Get.to(() => VerifyUser(
                  phoneNumber: _phoneController.text.toString(),
                  userName: _nameController.text.toString(),
                  userEmail: _emailController.text.toString(),
                  userPassword: _passwordController.text.toString(),
                  confirmPassword: _confrmpasswordController.text.toString(),
                  smsId: value.smsid.toString(),
                ));
          } else {
            Get.snackbar(value.message.toString(),
                'Email or/and phone number should be unique',
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                backgroundColor: Colors.white,
                colorText: Colors.red);
          }
        });
      } catch (e) {
        debugPrint(e.toString());
      }

      return true;
    }
    return false;
  }

  buildTextFormFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundedTextFormField(
          onSaved: (input) => requestModel1!.name = input,
          controller: _nameController,
          hintText: 'Name',
          validator: (input) {
            if (input.toString().length <= 2) {
              return 'Enter valid name.';
            }
            return null;
          },
        ),
        SizedBox(height: Config.Height * 0.01),
        RoundedTextFormField(
          controller: _emailController,
          onSaved: (input) => requestModel1!.email = input,
          hintText: 'Email',
          validator: (input) {
            bool _isEmailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(input!);
            if (!_isEmailValid) {
              return 'Invalid email.';
            }
            return null;
          },
        ),
        SizedBox(height: Config.Height * 0.01),
        RoundedTextFormField(
          controller: _phoneController,
          onSaved: (input) => requestModel1!.phoneNo = input,
          hintText: 'Mobile Number',
          validator: (input) {
            bool _isNumberValid = RegExp(r"^[6-9][0-9]{9}").hasMatch(input!);
            if (!_isNumberValid) {
              return 'Invalid phone number';
            }
            return null;
          },
        ),
        SizedBox(height: Config.Height * 0.01),
        RoundedPassWordTextFormField(
          controller: _passwordController,
          onSaved: (input) => requestModel1!.password = input,
          hintText: 'Password',
          validator: (input) {
            if (input.toString().length < 8) {
              return 'Password should be longer or equal to 8 characters.';
            }
            return null;
          },
        ),
        SizedBox(height: Config.Height * 0.01),
        RoundedPassWordTextFormField(
          controller: _confrmpasswordController,
          onSaved: (input) => requestModel1!.passwordConfirmation = input,
          hintText: 'Confirm Password',
          validator: (input) {
            if (input.trim() != _passwordController.text.trim()) {
              return 'Passwords does not match!';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class DeviceInfoApi {
  static final _deviceInfoPlugin = DeviceInfoPlugin();

  static Future<String> getDeviceAndroidId() async {
    String data = '';
    if (Platform.isAndroid) {
      final info = await _deviceInfoPlugin.androidInfo;
      data = "${info.androidId}";
    }
    return data;
  }
}
