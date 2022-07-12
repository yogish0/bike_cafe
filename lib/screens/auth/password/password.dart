import 'package:flutter/material.dart';
import 'package:bike_cafe/screens/auth/password/locale/password_form.dart';
import 'package:bike_cafe/widget/auth/ClipWidget.dart';
import 'package:bike_cafe/widget/config.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                child: clipWidget(
                  title: "Forgot",
                  subtitle: "Password",
                ),
                height: 200,
              ),
              SizedBox(height: Config.Height * 0.05),
              SizedBox(height: Config.Height * 0.05),
              const ResetForm(),
              SizedBox(height: Config.Height * 0.2),
            ],
          ),
        ),
      ),
    );
  }
}
