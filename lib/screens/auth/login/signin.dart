import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/controllers/geocontroller.dart';
import 'package:bike_cafe/models/auth/login_model.dart';
import 'package:bike_cafe/screens/Dashboard/Home/dashboard.dart';
import 'package:bike_cafe/screens/SlidingScreen/RegisterVehicle.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/auth/clipPath.dart';
import 'package:bike_cafe/widget/auth/txt_formfield.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/constrants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'dart:io';

import '../../../routes/routes.dart';
import '../sign_up/google_authentication.dart';
import '../sign_up/locale/social_auth_mobile_verification.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  LoginRequestModel? requestModel;
  LoginResponseModel? responseModel;

  // FlutterSecureStorage storage = FlutterSecureStorage();
  TextWidgetStyle style = TextWidgetStyle();
  final GeoController _controller = GeoController();

  bool? isApiCallProcess = true;
  List? data1;

  Box? box1;
  String UserAddress = '';

  //user device id
  String androidId = '';

  @override
  void initState() {
    super.initState();
    requestModel = LoginRequestModel();
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

  void getlogindata() async {
    if (box1!.get('email') != null) {
      _emailController.text = box1!.get('email');
    }
    if (box1!.get('password') != null) {
      _passwordController.text = box1!.get('password');
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  APIService apiService = APIService();

  GoogleAuthentication googleAuthentication = GoogleAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: isApiCallProcess == false
          ? Center(child: const CircularProgressIndicator(color: kPrimaryColor))
          : ListView(
              children: [
                SizedBox(
                  height: Config.Height * 1.2,
                  child: Column(
                    children: [
                      const ClipPathWidget(),
                      const SizedBox(height: 10),
                      Expanded(
                        flex: 2,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: RoundedTextFormField(
                                  controller: _emailController,
                                  type: TextInputType.emailAddress,
                                  hintText: 'Email / Mobile Number',
                                  onSaved: (input) =>
                                      requestModel!.email = input,
                                  validator: (input) {
                                    if (input == '') {
                                      return 'Enter Email / phone number';
                                    } else if (_emailController.text.isNum) {
                                      bool _isNumberValid =
                                          RegExp(r"^[6-9][0-9]{9}")
                                              .hasMatch(input!);
                                      if (!_isNumberValid) {
                                        return 'Invalid phone number';
                                      }
                                    } else {
                                      bool _isEmailValid = RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(input!);
                                      if (!_isEmailValid) {
                                        return 'Invalid email.';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: Config.Height * 0.03),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: RoundedPassWordTextFormField(
                                  controller: _passwordController,
                                  type: TextInputType.text,
                                  onSaved: (input) =>
                                      requestModel!.password = input,
                                  hintText: 'Password',
                                  validator: (input) {
                                    if (input == '') {
                                      return 'Enter password';
                                    }
                                    if (input.toString().length < 6) {
                                      return 'Password should be longer or equal to 6 characters.';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: Config.Height * 0.03),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: style.Roboto(
                                          text: "Sign In",
                                          fontwight: FontWeight.w700,
                                          size: 30,
                                          color: Colors.black)),
                                  const Spacer(),
                                  FloatingActionButton(
                                    backgroundColor: kPrimaryColor,
                                    child: const Icon(
                                        Icons.arrow_right_alt_rounded,
                                        size: 35),
                                    onPressed: () async {
                                      // Get.off(Dashboard());
                                      if (_formKey.currentState!.validate()) {
                                        // print('object');
                                        if (validateAndSave()) {
                                          box1!.put(
                                              'email', _emailController.text);
                                          box1!.put('password',
                                              _passwordController.text);

                                          // setState(() {
                                          //   isApiCallProcess = true;
                                          //   Center(child: const CircularProgressIndicator());
                                          // });

                                          // requestModel!.loginType = "email";
                                          requestModel!.email =
                                              _emailController.text.toString();
                                          requestModel!.password =
                                              _passwordController.text
                                                  .toString();

                                          requestModel!.andriod_id =
                                              androidId.toString();
                                          requestModel!.deviceToken = box1!
                                              .get('device_token')
                                              .toString();
                                          requestModel!.web_id = ''.toString();
                                          try {
                                            var loginRequest;
                                            // if (_emailController.text.isNum) {
                                            //   loginRequest =
                                            //       apiService.loginUsingNumber(
                                            //     mobileNumber: _emailController
                                            //         .text
                                            //         .toString(),
                                            //     password: _passwordController
                                            //         .text
                                            //         .toString(),
                                            //     deviceToken:
                                            //         box1!.get('device_token'),
                                            //   );
                                            // }
                                            //  else {
                                            loginRequest = apiService.login(
                                                requestModel!,
                                                "loginbyemailorphone");
                                            // }

                                            loginRequest.then((input) async {
                                              if (input != null) {
                                                setState(() {
                                                  isApiCallProcess = false;
                                                });
                                                if (input
                                                    .apiToken!.isNotEmpty) {
                                                  // setState(() {
                                                  //   isApiCallProcess = true;
                                                  // });
                                                  // Get.off(() => BottomNavBarPage());

                                                  List data = [
                                                    input.user!.name,
                                                    input.user!.phonenumber,
                                                    input.user!.email,
                                                    input.user!.id,
                                                    input.apiToken
                                                  ];
                                                  String name =
                                                      data[0].toString();
                                                  String phonenumber =
                                                      data[1].toString();
                                                  String email =
                                                      data[2].toString();
                                                  String id =
                                                      data[3].toString();
                                                  String token =
                                                      data[4].toString();
                                                  debugPrint(name);
                                                  debugPrint(phonenumber);
                                                  debugPrint(email);
                                                  debugPrint(id);
                                                  debugPrint(token);

                                                  if (token != "null") {
                                                    var checkVehicleList =
                                                        apiService
                                                            .getvechiledetailsbyuserid(
                                                                token: token,
                                                                id: id);
                                                    checkVehicleList
                                                        ?.then((value) {
                                                      debugPrint('len ' +
                                                          value!.body.length
                                                              .toString());
                                                      value.body.isEmpty
                                                          ? Get.off(() =>
                                                              const RegisterVehicle())
                                                          : Get.off(() =>
                                                              Dashboard());
                                                    });
                                                  } else {
                                                    Get.offAll(() => SignIn());
                                                  }
                                                  box1!.put('data0', name);
                                                  box1!.put(
                                                      'data1', phonenumber);
                                                  box1!.put('data2', email);
                                                  box1!.put('data3', id);
                                                  box1!.put('data4', token);

                                                  box1!.put('isLogged', true);
                                                  box1!.put(
                                                      "welcomeNotification",
                                                      false);

                                                  setState(() {
                                                    isApiCallProcess = false;
                                                  });
                                                } else {
                                                  Get.snackbar(
                                                      "Error in login in",
                                                      input.toString(),
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      backgroundColor:
                                                          kPrimaryColor,
                                                      colorText:
                                                          kBackgroundColor);
                                                  debugPrint("failed");
                                                }
                                              }
                                            });
                                          } catch (e) {
                                            Get.snackbar("Error in login in",
                                                e.toString(),
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor: kPrimaryColor,
                                                colorText: kBackgroundColor);
                                          }
                                        }
                                        setState(() {
                                          isApiCallProcess = false;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 30)
                                ],
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 12),
                                    // Row(
                                    //   children: [
                                    //     const SizedBox(width: 8),
                                    //     Text(
                                    //       "Sign with",
                                    //       style: TextStyle(
                                    //           color: Colors.black,
                                    //           fontWeight: FontWeight.w400,
                                    //           fontSize: 18,
                                    //           fontFamily: GoogleFonts.roboto().fontFamily
                                    //       ),
                                    //     ),
                                    //     SignInButton.mini(
                                    //       buttonType: ButtonType.google,
                                    //       onPressed: () async{
                                    //         try {
                                    //             setState(() {
                                    //                   isApiCallProcess=true;
                                    //                 });
                                    //          await googleAuthentication
                                    //               .googleSignIn()
                                    //               .then((value) async{
                                    //             final googleUserData = FirebaseAuth
                                    //                 .instance.currentUser;
                                    //             print(googleUserData?.email!
                                    //                 .toString());
                                    //                 setState(() {
                                    //                   isApiCallProcess=true;
                                    //                 });
                                    //           await  apiService
                                    //                 .checkSocialAuthUserApi(
                                    //                     email: googleUserData
                                    //                         ?.email!
                                    //                         .toString())
                                    //                 .then((value) async{
                                    //               if (value!.isavailable == "1") {
                                    //                await apiService
                                    //                     .socialAuthUserApi(
                                    //                         email: googleUserData
                                    //                             ?.email!,
                                    //                         userName: googleUserData
                                    //                             ?.displayName!,
                                    //                         deviceToken: androidId,
                                    //                         mailIdToken:
                                    //                             googleUserData?.uid,
                                    //                         authType: "email",
                                    //                         phoneNumber: null)
                                    //                     .then((value) {
                                    //                   if (value!.apiToken !=
                                    //                       "null") {
                                    //                     box1!.put(
                                    //                         'data0',
                                    //                         value.user!.name
                                    //                             .toString());
                                    //                     box1!.put(
                                    //                         'data1',
                                    //                         value.user!.phonenumber
                                    //                             .toString());
                                    //                     box1!.put(
                                    //                         'data2',
                                    //                         value.user!.email
                                    //                             .toString());
                                    //                     box1!.put(
                                    //                         'data3',
                                    //                         value.user!.id
                                    //                             .toString());
                                    //                     box1!.put(
                                    //                         'data4',
                                    //                         value.apiToken
                                    //                             .toString());
                                    //                     box1!.put('isLogged', true);
                                    //                     box1!.put(
                                    //                         "welcomeNotification",
                                    //                         false);
                                    //                     box1!.put(
                                    //                         "isGoogleAuth", true);
                                    //                     var checkVehicleList = apiService
                                    //                         .getvechiledetailsbyuserid(
                                    //                             token: value
                                    //                                 .apiToken
                                    //                                 .toString(),
                                    //                             id: value.user!.id
                                    //                                 .toString());
                                    //                                   setState(() {
                                    //                   isApiCallProcess=false;
                                    //                 });
                                    //                     checkVehicleList
                                    //                         ?.then((value) {
                                    //                       value!.body.isEmpty
                                    //                           ? Get.off(() =>
                                    //                               const RegisterVehicle())
                                    //                           : Get.off(() =>
                                    //                               Dashboard());
                                    //                     });
                                    //                   } else {
                                    //                     Fluttertoast.showToast(
                                    //                         msg: "Sign in failed"
                                    //                             "");
                                    //                     googleAuthentication.logOut();
                                    //                   }
                                    //                 });
                                    //               } else {
                                    //                 Get.to(() =>
                                    //                     SocialAuthMobileVerification(
                                    //                         email: googleUserData
                                    //                             ?.email!,
                                    //                         userName: googleUserData
                                    //                             ?.displayName!,
                                    //                         deviceToken: androidId,
                                    //                         mailIdToken:
                                    //                             googleUserData?.uid,
                                    //                         authType: "email"));
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
                                    // SignInButton.mini(
                                    //   buttonType: ButtonType.facebook,
                                    //   onPressed: () {},
                                    // ),
                                    // const Spacer(),
                                    Row(
                                      children: [
                                        style.Roboto(
                                            text: "Don't have account? ",
                                            fontwight: FontWeight.w400,
                                            color: Colors.black),
                                        TextButton(
                                          child: Constants.linkText("Sign Up"),
                                          onPressed: () =>
                                              Get.toNamed(Routes.signUp),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    child:
                                        Constants.linkText("Forgot Password ?"),
                                    onPressed: () =>
                                        Get.toNamed(Routes.forgotpwd),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
