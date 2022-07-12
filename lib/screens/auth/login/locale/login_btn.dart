import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/routes/routes.dart';
import 'package:bike_cafe/widget/config.dart';

class SignInButtons extends StatelessWidget {
  const SignInButtons({
    Key? key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _formKey = formKey,
        _emailController = emailController,
        _passwordController = passwordController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    TextWidgetStyle style = TextWidgetStyle();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          child: style.Roboto(
              text: "Sign up",
              fontwight: FontWeight.w400,
              size: 18,
              color: Colors.black),
          onPressed: () => Get.toNamed(Routes.signUp),
        ),
        TextButton(
          child: style.Roboto(
              text: "Forgot Password ?",
              fontwight: FontWeight.w400,
              size: 18,
              color: Colors.black),
          onPressed: () => Get.toNamed(Routes.forgotpwd),
          style: ButtonStyle(
            overlayColor:
                MaterialStateColor.resolveWith((states) => Colors.transparent),
          ),
        ),
      ],
    );
  }
}
