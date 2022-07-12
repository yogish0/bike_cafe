import 'package:flutter/material.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';

class UserWallet extends StatelessWidget {
  const UserWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      title: 'My Wallet',
      body: Center(child: Text('Coming Soon...', style: TextStyle(color: Colors.red, fontSize: 30)),),
    );
  }
}
