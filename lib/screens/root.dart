import 'package:flutter/material.dart';
import 'package:bike_cafe/screens/Dashboard/Home/dashboard.dart';
import 'package:bike_cafe/screens/auth/login/signin.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Root extends StatefulWidget {
  Root({Key? key, this.data}) : super(key: key);

  List? data;

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  Box? box1;

  @override
  void initState() {
    // TODO: implement initState
    OpenBox();
  }

  void OpenBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    return box1?.get('isLogged', defaultValue: false) == null
        ? const Center()
        : SafeArea(
            child: box1?.get('isLogged', defaultValue: false)
                ? Dashboard()
                : const SignIn(),
          );
  }
}
