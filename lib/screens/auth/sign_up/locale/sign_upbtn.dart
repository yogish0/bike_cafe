// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/controllers/authcontroller.dart';
import 'package:bike_cafe/models/auth/login_model.dart';
import 'package:bike_cafe/models/auth/signIn_model.dart';

import 'package:bike_cafe/screens/root.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/auth/button.dart';
import 'package:bike_cafe/widget/auth/txt_bttn.dart';
import 'package:bike_cafe/widget/config.dart';

class SignUpButtons extends StatefulWidget {
  SignUpButtons({
    Key? key,
    required GlobalKey<FormState> formKey,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController passwordController,
  })  : _formKey = formKey,
        _nameController = nameController,
        _emailController = emailController,
        _phoneController = phoneController,
        _passwordController = passwordController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController _nameController;
  final TextEditingController _emailController;
  final TextEditingController _phoneController;

  final TextEditingController _passwordController;

  @override
  State<SignUpButtons> createState() => _SignUpButtonsState();
}

class _SignUpButtonsState extends State<SignUpButtons> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _authController = Get.find<AuthController>();

    return Expanded(
      flex: 4,
      child: Column(
        children: [
          RoundedElevatedButton(
            onPressed: () {},
            title: 'Sign up',
            padding: EdgeInsets.symmetric(
              horizontal: Config.Height * 0.38,
              vertical: Config.Height * 0.02,
            ),
          ),
        ],
      ),
    );
  }
}
