import 'package:flutter/material.dart';
import '../otp_login/locale/otp_loginform.dart';

class Otp_login extends StatelessWidget {
  const Otp_login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opt_form(),
            ],
          ),
        ),
      ),
    );
  }
}
