import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../../services/api.dart';
import '../../../../widget/auth/ClipWidget.dart';
import '../../../../widget/auth/txt_formfield.dart';
import '../../../../widget/config.dart';
import '../../../Dashboard/Home/dashboard.dart';
import '../../../SlidingScreen/RegisterVehicle.dart';

class SocialAuthMobileVerification extends StatefulWidget {
  SocialAuthMobileVerification({Key? key, this.email, this.userName, this.deviceToken, this.mailIdToken, this.authType}) : super(key: key);

  String? email, userName, deviceToken, mailIdToken, authType;

  @override
  _SocialAuthMobileVerificationState createState() => _SocialAuthMobileVerificationState();
}

class _SocialAuthMobileVerificationState extends State<SocialAuthMobileVerification> {

  Box? box1;

  @override
  void initState() {
    super.initState();
    createBox();
  }

  void createBox() async {
    box1 = await Hive.openBox('logindata');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                child: clipWidget(
                  title: "Verify",
                  subtitle: "Mobile",
                ),
                height: 200,
              ),
              SizedBox(height: Config.Height * 0.05),
              SizedBox(height: Config.Height * 0.05),
              mobileVerifyWidget(),
              SizedBox(height: Config.Height * 0.2),
            ],
          ),
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  APIService apiService = APIService();
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      try{
        apiService.OtpToMobileNumberVerify(phoneNumber: _mobileController.text.toString()).then((value){
          if(value?.success == 1){
            var smsIdResponse = value?.smsid.toString();
            Get.defaultDialog(
              title: "OTP Verification",
              content: otpPopup(),
              onCancel: (){
                _otpController.text ='';
              },
              onConfirm: (){
                final form = _formKey2.currentState;
                if (form!.validate()){
                  form.save();
                  try{
                    var verify = apiService.verifyUserByOtpToRegisterApi(otpId: smsIdResponse.toString(), userOtp: _otpController.text.toString());
                    verify.then((value){
                      if(value?.success == 1){
                        _otpController.text ='';
                        apiService.socialAuthUserApi(
                            email: widget.email,
                            userName: widget.userName,
                            deviceToken: box1!.get("device_token"),
                            mailIdToken: widget.mailIdToken,
                            authType: widget.authType,
                            phoneNumber: _mobileController.text.toString(),
                            androidId: widget.deviceToken
                        ).then((value){
                          if(value!.success == 1){
                            if (value.apiToken != "null") {
                              box1!.put('data0', value.user!.name.toString());
                              box1!.put('data1', value.user!.phonenumber.toString());
                              box1!.put('data2', value.user!.email.toString());
                              box1!.put('data3', value.user!.id.toString());
                              box1!.put('data4', value.apiToken.toString());
                              box1!.put('isLogged', true);
                              box1!.put("welcomeNotification", false);
                              box1!.put("isGoogleAuth", true);
                              var checkVehicleList =
                              apiService.getvechiledetailsbyuserid(
                                  token: value.apiToken.toString(),
                                  id: value.user!.id.toString());
                              checkVehicleList?.then((value) {
                                value!.body.isEmpty
                                    ? Get.off(() => const RegisterVehicle())
                                    : Get.off(() => Dashboard());
                              });
                            }
                          }else{
                            Fluttertoast.showToast(msg: value.message.toString());
                          }
                        });
                      }
                    });
                  }catch(e){
                    debugPrint(e.toString());
                  }
                }
              },
              textConfirm: 'Verify',
              buttonColor: kPrimaryColor,
              cancelTextColor: kPrimaryColor,
              confirmTextColor: Colors.white,
            );
          }else{
            Fluttertoast.showToast(msg: "Entered mobile number already exist");
          }
        });
      }catch(e){
        debugPrint(e.toString());
      }
      return true;
    }
    return false;
  }

  //otp popup
  Widget otpPopup() {
    return Column(
      children: [
        const Text('Enter OTP sent your mobile number'),
        const SizedBox(height: 10),
        Text('+91 ' + _mobileController.text.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                decoration: formDecor2('Enter OTP')
            ),
          ),
        ),
      ],
    );
  }

  formDecor2(String hint) {
    return InputDecoration(
      hintText: hint,
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: containerColor),
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: containerColor),
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      fillColor: Colors.white,
      filled: true,
    );
  }

  Widget mobileVerifyWidget(){
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: Config.Height * 0.05),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text('Enter mobile number'),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                Expanded(
                  child: RoundedTextFormField(
                    hintText: 'Mobile Number',
                    controller: _mobileController,
                    validator: (value) {
                      bool _isnumberValid = RegExp(r"^[6-9][0-9]{9}").hasMatch(value!);
                      if(value == ''){
                        return 'Enter Mobile Number';
                      }else if (!_isnumberValid) {
                        return 'Invalid Number.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  backgroundColor: kPrimaryColor,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
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
