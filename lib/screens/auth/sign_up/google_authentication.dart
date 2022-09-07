import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleAccount;

  GoogleSignInAccount get googleAccountUser => googleAccount!;

  Future<void> googleSignIn() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      googleAccount = googleUser;
    }

    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future logOut() async {
    await _googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
