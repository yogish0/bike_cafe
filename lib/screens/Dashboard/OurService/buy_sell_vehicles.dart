import 'package:flutter/material.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';

class BuyAndSellVehicles extends StatefulWidget {
  const BuyAndSellVehicles({Key? key}) : super(key: key);

  @override
  _BuyAndSellVehiclesState createState() => _BuyAndSellVehiclesState();
}

class _BuyAndSellVehiclesState extends State<BuyAndSellVehicles> {
  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      title: 'Services',
      body: Container(
        child: Center(
          child: Text("Coming Soon...",
              style: TextStyle(fontSize: 24, color: Colors.red)),
        ),
      ),
    );
  }
}
