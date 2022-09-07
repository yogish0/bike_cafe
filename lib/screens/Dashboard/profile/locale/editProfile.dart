// ignore: file_names
// ignore_for_file: unused_import, must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/models/UserProfile/usermodel.dart';
import 'package:bike_cafe/models/UserProfile/userprofile.dart';
import 'package:bike_cafe/models/editprofile/editprofilemodel.dart';
import 'package:bike_cafe/screens/Dashboard/Address/locale/editadress.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/themes/CirucularIndication/progressHud.dart';
import 'package:bike_cafe/widget/auth/textformfield.dart';
import 'package:bike_cafe/widget/auth/txt_formfield.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:bike_cafe/widget/constrants.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../profile.dart';
import 'gallery_widget.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key, this.token, this.userId}) : super(key: key);

  String? token;
  String? userId;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Box? box1;
  APIService service = APIService();
  String previousName = '';
  String previousEmail = '';
  String previousNumber = '';

  @override
  void initState() {
    super.initState();
    createBox();
    service
        .getUserProfileApi(token: widget.token, userId: widget.userId)
        .then((value) {
      setState(() {
        previousName = value!.user[0].name.toString();
        previousEmail = value.user[0].email.toString();
        previousNumber = value.user[0].phonenumber.toString();
        _nameController.value =
            TextEditingValue(text: value.user[0].name.toString());
        _emailController.value =
            TextEditingValue(text: value.user[0].email.toString());
        _numberController.value =
            TextEditingValue(text: value.user[0].phonenumber.toString());
      });
    });
  }

  void createBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {});
  }

  bool validateNameAndUpdate() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      if (previousName != _nameController.text) {
        try {
          final String name = _nameController.text.toString();
          final String email = previousEmail.toString();
          final String number = previousNumber.toString();
          var model = service.edituser(
              id: box1?.get("data3"),
              token: box1?.get("data4"),
              name: name,
              email: email,
              number: number);
          model.then((value) {
            if (value?.success == 1) {
              Fluttertoast.showToast(msg: "Profile name updated");
            }
            previousName = _nameController.text.toString();
          });
        } catch (e) {
          debugPrint("falied");
        }
      }
      return true;
    }
    return false;
  }

  bool validateEmailAndUpdate() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      if (previousEmail != _emailController.text) {
        try {
          final String name = previousName.toString();
          final String email = _emailController.text.toString();
          final String number = previousNumber.toString();
          var model = service.edituser(
              id: box1?.get("data3"),
              token: box1?.get("data4"),
              name: name,
              email: email,
              number: number);
          model.then((value) {
            if (value?.success == 1) {
              Fluttertoast.showToast(msg: "Email address updated");
            }
            previousEmail = _emailController.text;
          });
        } catch (e) {
          debugPrint("falied");
        }
      }
      return true;
    }
    return false;
  }

  bool validateNumberAndUpdate() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      if (previousNumber != _numberController.text) {
        try {
          final String name = previousName.toString();
          final String email = previousEmail.toString();
          final String number = _numberController.text.toString();

          var sendOtp =
              service.OtpToMobileNumberVerify(phoneNumber: number.toString());
          sendOtp.then((value) {
            var smsIdResponse = value?.smsid.toString();
            if (value!.success == 1) {
              Get.defaultDialog(
                title: 'OTP Verification',
                content: otpPopup2(),
                onCancel: () {
                  _otpController2.text = '';
                },
                onConfirm: () {
                  if (form.validate()) {
                    final form = _formKey4.currentState;
                    form?.save();
                    try {
                      var verify = service.verifyUserByOtpToRegisterApi(
                          otpId: smsIdResponse.toString(),
                          userOtp: _otpController2.text.toString());
                      verify.then((value) {
                        if (value?.success == 1) {
                          _otpController2.text = '';
                          var editNumber = service.edituser(
                              id: box1?.get("data3"),
                              token: box1?.get("data4"),
                              name: name,
                              email: email,
                              number: number);
                          editNumber.then((value) {
                            if (value?.success == 1) {
                              Fluttertoast.showToast(
                                  msg: "Phone number updated");
                              Get.back();
                            } else {
                              Fluttertoast.showToast(msg: "failed to update");
                              setState(() {
                                _numberController.value = TextEditingValue(
                                    text: previousNumber.toString());
                              });
                              Get.back();
                            }
                          });
                        } else {
                          _otpController2.text = '';
                          Fluttertoast.showToast(msg: "Verification failed");
                          setState(() {
                            _numberController.value = TextEditingValue(
                                text: previousNumber.toString());
                          });
                          Get.back();
                        }
                      });
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  }
                },
                textConfirm: 'Verify',
                buttonColor: kPrimaryColor,
                cancelTextColor: kPrimaryColor,
                confirmTextColor: Colors.white,
              );
            } else {
              Fluttertoast.showToast(msg: value.message.toString());
            }
          });
        } catch (e) {
          debugPrint("falied");
        }
      }
      return true;
    }
    return false;
  }

  bool validateOtp() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  EditUserModelDetails? usermodel;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _alternumberController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  TextEditingController _otpController = TextEditingController();
  TextEditingController _otpController2 = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();

  bool isApiCallProcess = false;

  boxDecor() {
    return const BoxDecoration(
      boxShadow: [
        BoxShadow(color: Colors.grey, offset: Offset(0, 1), blurRadius: 6.0),
      ],
    );
  }

  formDecor(String hint, Function()? onPressed) {
    return InputDecoration(
        // border: InputBorder.none,
        hintText: hint,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: containerColor),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: containerColor),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        contentPadding: const EdgeInsets.symmetric(vertical: 6),
        fillColor: Colors.white,
        filled: true,
        suffixIcon: TextButton(
          onPressed: () {
            onPressed!();
            FocusScope.of(context).unfocus();
          },
          child: const Text(
            "Update",
            style: TextStyle(color: Colors.black),
          ),
        ));
  }

  formDecor2(String hint) {
    return InputDecoration(
      // border: InputBorder.none,
      hintText: hint,
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: containerColor),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: containerColor),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      fillColor: Colors.white,
      filled: true,
    );
  }

  File? image;
  final picker = ImagePicker();

  //pick image from gallery/camera
  Future pickImage(ImageSource imgSource, String token, String userId) async {
    final pickedFile =
        await picker.pickImage(source: imgSource, imageQuality: 50);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      if (image != null) {
        service
            .uploadProfilePhotoApi(token: token, userId: userId, img: image!)
            .then((value) {
          setState(() {});
        });
      }
      setState(() {});
    } else {
      debugPrint('no image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return box1?.get("data4") == null
        ? const Center(child: CircularProgressIndicator())
        : GetScaffold(
            index: 6,
            title: 'My Profile',
            body: Scaffold(
              backgroundColor: Constants.bgcolor,
              key: scaffoldKey,
              body: box1?.get('data4') == null
                  ? const Center()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          FutureBuilder<GetUserProfileData?>(
                            future: service.getUserProfileApi(
                                token: box1?.get('data4'),
                                userId: box1?.get('data3')),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                  children: [
                                    for (var i = 0;
                                        i < snapshot.data!.user.length;
                                        i++)
                                      profileCover(i, snapshot),
                                  ],
                                );
                              } else {
                                return const Center();
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  Container(
                                    decoration: boxDecor(),
                                    child: TextFormField(
                                        controller: _nameController,
                                        onSaved: (input) =>
                                            usermodel?.name = input,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.text,
                                        validator: (input) {
                                          if (input.toString().length <= 2) {
                                            return 'Enter valid name.';
                                          }
                                          return null;
                                        },
                                        decoration: formDecor('Full Name',
                                            validateNameAndUpdate)),
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    decoration: boxDecor(),
                                    child: TextFormField(
                                        controller: _emailController,
                                        onSaved: (input) =>
                                            usermodel?.name = input,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.text,
                                        validator: (input) {
                                          bool _isEmailValid = RegExp(
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(input!);
                                          if (!_isEmailValid) {
                                            return 'Invalid email.';
                                          }
                                          return null;
                                        },
                                        decoration: formDecor('Email address',
                                            validateEmailAndUpdate)),
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    decoration: boxDecor(),
                                    child: TextFormField(
                                        controller: _numberController,
                                        onSaved: (input) =>
                                            usermodel?.name = input,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.text,
                                        validator: (input) {
                                          bool _isEmailValid =
                                              RegExp(r"^[6-9][0-9]{9}")
                                                  .hasMatch(input!);
                                          if (!_isEmailValid) {
                                            return 'Invalid phone number';
                                          }
                                          return null;
                                        },
                                        decoration: formDecor('Phone number',
                                            validateNumberAndUpdate)),
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(),
                                  ListTile(
                                    title: const Text("Change password"),
                                    onTap: () {
                                      try {
                                        service
                                            .forgotPasswordOtpApi(
                                                phoneNumber: _numberController
                                                    .text
                                                    .toString())
                                            .then((value) {
                                          if (value?.userid != null) {
                                            Get.defaultDialog(
                                              title: "OTP Verification",
                                              content: otpPopup(),
                                              onCancel: () {
                                                _otpController.text = '';
                                              },
                                              onConfirm: () {
                                                final form =
                                                    _formKey2.currentState;
                                                if (form!.validate()) {
                                                  form.save();
                                                  try {
                                                    var verify = service
                                                        .verifyUserByOtpApi(
                                                            userId:
                                                                widget.userId,
                                                            userOtp:
                                                                _otpController
                                                                    .text
                                                                    .toString());
                                                    verify.then((value) {
                                                      if (value!.success == 1) {
                                                        Get.defaultDialog(
                                                          title:
                                                              "Change password",
                                                          content:
                                                              changePasswordPopup(),
                                                          onCancel: () {
                                                            _otpController
                                                                .text = '';
                                                            _passwordController
                                                                .text = '';
                                                            _confirmController
                                                                .text = '';
                                                            Get.back();
                                                          },
                                                          onConfirm: () {
                                                            final form = _formKey3
                                                                .currentState;
                                                            if (form!
                                                                .validate()) {
                                                              form.save();
                                                              try {
                                                                var resetResponse = service.resetPasswordApi(
                                                                    userId: widget
                                                                        .userId
                                                                        .toString(),
                                                                    password:
                                                                        _passwordController
                                                                            .text
                                                                            .toString());
                                                                resetResponse
                                                                    .then(
                                                                        (value) {
                                                                  if (value
                                                                          ?.success ==
                                                                      1) {
                                                                    _otpController
                                                                        .text = '';
                                                                    _passwordController
                                                                        .text = '';
                                                                    _confirmController
                                                                        .text = '';
                                                                    Get.back();
                                                                    Get.back();
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Password updated");
                                                                  }
                                                                });
                                                              } catch (e) {
                                                                debugPrint(e
                                                                    .toString());
                                                              }
                                                            }
                                                          },
                                                          textConfirm: 'Update',
                                                          buttonColor:
                                                              kPrimaryColor,
                                                          cancelTextColor:
                                                              kPrimaryColor,
                                                          confirmTextColor:
                                                              Colors.white,
                                                        );
                                                      }
                                                    });
                                                  } catch (e) {
                                                    debugPrint(e.toString());
                                                  }
                                                }
                                              },
                                              textConfirm: 'Submit',
                                              buttonColor: kPrimaryColor,
                                              cancelTextColor: kPrimaryColor,
                                              confirmTextColor: Colors.white,
                                            );
                                          }
                                        });
                                      } catch (e) {
                                        debugPrint(e.toString());
                                      }
                                    },
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          );
  }

  //change password popup
  Widget changePasswordPopup() {
    return Column(
      children: [
        // const Text('Change password'),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          // decoration: boxDecor(),
          child: Form(
            key: _formKey3,
            child: Column(
              children: [
                TextFormField(
                    controller: _passwordController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    validator: (input) {
                      if (input == '') {
                        return 'Enter password';
                      } else if (input.toString().length < 8) {
                        return 'Password should be longer or equal to 8 characters.';
                      }
                      return null;
                    },
                    decoration: formDecor2('New password')),
                const SizedBox(height: 15),
                TextFormField(
                    controller: _confirmController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    validator: (input) {
                      if (input == '') {
                        return 'Enter password';
                      } else if (input?.trim() !=
                          _passwordController.text.trim()) {
                        return 'Passwords does not match!';
                      }
                      return null;
                    },
                    decoration: formDecor2('Confirm password')),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //otp popup
  Widget otpPopup() {
    return Column(
      children: [
        const Text('Enter OTP sent your mobile number'),
        const SizedBox(height: 10),
        Text('+91 ' + previousNumber.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          // decoration: boxDecor(),
          child: Form(
            key: _formKey2,
            child: TextFormField(
                controller: _otpController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                validator: (input) {
                  bool _isNumberValid = RegExp(r"^[0-9]{6}").hasMatch(input!);
                  if (input == '') {
                    return 'Enter OTP';
                  } else if (!_isNumberValid) {
                    return 'Invalid OTP';
                  }
                  return null;
                },
                decoration: formDecor2('Enter OTP')),
          ),
        ),
      ],
    );
  }

  //otp popup
  Widget otpPopup2() {
    return Column(
      children: [
        const Text('Enter OTP sent your mobile number'),
        const SizedBox(height: 10),
        Text('+91 ' + _numberController.text.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          // decoration: boxDecor(),
          child: Form(
            key: _formKey4,
            child: TextFormField(
                controller: _otpController2,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                validator: (input) {
                  bool _isNumberValid = RegExp(r"^[0-9]{6}").hasMatch(input!);
                  if (input == '') {
                    return 'Enter OTP';
                  } else if (!_isNumberValid) {
                    return 'Invalid OTP';
                  }
                  return null;
                },
                decoration: formDecor2('Enter OTP')),
          ),
        ),
      ],
    );
  }

  Widget profileCover(int index, AsyncSnapshot<GetUserProfileData?> snapshot) {
    var user = snapshot.data!.user[index];
    var imageList = [
      "https://" + user.profilePhotoPath.toString(),
    ];
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.only(top: 12, left: 24, bottom: 24),
        color: Colors.white,
        child: Row(
          children: [
            Stack(
              children: [
                ClipOval(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 120,
                    width: 120,
                    child: user.profilePhotoPath == null
                        ? const Icon(Icons.account_circle_sharp,
                            size: 130, color: Colors.black54)
                        : InkWell(
                            onTap: () {
                              Get.to(() => GalleryWidget(urlImages: imageList));
                            },
                            child: Image.network(
                              "https://" + user.profilePhotoPath.toString(),
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                              errorBuilder: (context, img, image) {
                                return Image.asset(
                                    "assets/img/no_image_available.jpg",
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100);
                              },
                            ),
                          ),
                  ),
                ),
                Positioned(
                  right: -6,
                  bottom: -4,
                  child: IconButton(
                      icon: const Icon(Icons.camera_alt_outlined,
                          color: kPrimaryColor),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => uploadOptions(user),
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(15)),
                          ),
                        );
                      }),
                )
              ],
            ),
            Expanded(
              child: Image.asset("assets/img/love_bikecafe.png",
                  fit: BoxFit.cover),
            )
          ],
        ),
      ),
    );
  }

  bool cameraPermission = false;
  bool storagePermission = false;

  //ask permission for camera
  void checkCameraPermission() async {
    if (await Permission.camera.request().isGranted) {
      setState(() {
        cameraPermission = true;
      });
      pickImage(ImageSource.camera, box1?.get('data4'), box1?.get('data3'));
    } else if (await Permission.camera.request().isPermanentlyDenied) {
      await openAppSettings();
      debugPrint('object3');
    } else if (await Permission.camera.request().isDenied) {
      debugPrint('object4');

      setState(() {
        cameraPermission = false;
      });
    }
  }

  //ask permission for storage
  void checkStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        storagePermission = true;
      });
      pickImage(ImageSource.gallery, box1?.get('data4'), box1?.get('data3'));
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
      debugPrint('object3');
    } else if (await Permission.storage.request().isDenied) {
      debugPrint('object4');

      setState(() {
        storagePermission = false;
      });
    }
  }

  //image upload options
  Widget uploadOptions(User user) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              // pickImage(ImageSource.camera, box1?.get('data4'), box1?.get('data3'));
              checkCameraPermission();
              Get.back();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.camera_alt, size: 30),
                SizedBox(height: 4),
                Text('Camera')
              ],
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: () {
              // pickImage(ImageSource.gallery, box1?.get('data4'), box1?.get('data3'));
              checkStoragePermission();
              Get.back();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.photo_library, size: 30),
                SizedBox(height: 4),
                Text('Gallery')
              ],
            ),
          )
        ],
      ),
    );
  }
}
