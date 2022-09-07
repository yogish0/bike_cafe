import 'package:flutter/material.dart';
import 'package:bike_cafe/screens/Dashboard/Address/locale/addresspage.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      index: 6,
      title: "My Address",
      // body: AddressPageList(),
    );
  }
}
