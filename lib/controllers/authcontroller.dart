// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:getx_loginpage/screens/root.dart';
// import 'package:getx_loginpage/widget/config.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  // var displayName = '';
  // FirebaseAuth auth = FirebaseAuth.instance;
  // var _googleSignIn = GoogleSignIn();

  // var googleAcc = Rx<GoogleSignInAccount?>(null);
  // var isSignedIn = false.obs;
  // Map? userObj = {};

  // User? get userProfile => auth.currentUser;
  // final googlesignin = GoogleSignIn();

  // GoogleSignInAccount? _user;
  // GoogleSignInAccount get user => _user!;
  // var status_string = "welcome".obs;
  // var code_sent = "no".obs;
  // var verification_id = "1".obs;

  // String get status_result => status_string.value;
  // String get code_sent_result => code_sent.value;
  // String get ver_result => verification_id.value;

  // String? _verificationcode;
  // String? phoneNumber;
  // int? resendToken;

  // @override
  // void onInit() {
  //   displayName = userProfile != null ? userProfile!.displayName! : '';

  //   super.onInit();
  // }

  // void signInWithGoogle() async {
  //   try {
  //     final googleuser = await googlesignin.signIn();
  //     if (googleuser == null) return;
  //     _user = googleuser;
  //     final googleAuth = await googleuser.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     displayName = googleAcc.value!.displayName!;
  //     // isSignedIn.value = true;

  //     update(); // <-- without this the isSignedin value is not updated.
  //   } catch (e) {
  //     print(e);
  //     Get.snackbar('Error occured!', e.toString(),
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: kPrimaryColor,
  //         colorText: kBackgroundColor);
  //   }
  // }

  // void signInwithFaceook() async {
  //   var result = await FacebookAuth.instance
  //       .login(permissions: ['email', 'pulic_profile']);
  //   try {
  //     switch (result.status) {
  //       case LoginStatus.success:
  //         final AuthCredential facebookCredential =
  //             FacebookAuthProvider.credential(result.accessToken!.token);
  //         // ignore: non_constant_identifier_names
  //         final UserCred = await Get.find<AuthController>()
  //             .auth
  //             .signInWithCredential(facebookCredential);
  //         isSignedIn.value = true;
  //         update();
  //         break;
  //       case LoginStatus.cancelled:
  //         // TODO: Handle this case.
  //         break;
  //       case LoginStatus.failed:
  //         // TODO: Handle this case.
  //         break;
  //       case LoginStatus.operationInProgress:
  //         // TODO: Handle this case.
  //         break;
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error occured!', e.toString(),
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: kPrimaryColor,
  //         colorText: kBackgroundColor);
  //   }
  // }
}
