import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthentication{
  Map<String, dynamic>? fbUserData;
  Future<UserCredential?> facebookLogin() async {
    try {
      final LoginResult result_ = await FacebookAuth.instance
          .login(permissions: ["public_profile", "email"]);

      if (result_.status == LoginStatus.success) {
        final requestData =
        await FacebookAuth.instance.getUserData(fields: "email, name, id");
        fbUserData = requestData;
      } else {
        debugPrint(result_.message.toString());
      }

      final OAuthCredential oAuthCredential =
      FacebookAuthProvider.credential(result_.accessToken!.token);
      return await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}