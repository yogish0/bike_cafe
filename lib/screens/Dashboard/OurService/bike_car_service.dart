import 'package:flutter/material.dart';
import 'package:bike_cafe/widget/locale/scaffold.dart';

class BikeAndCarServices extends StatefulWidget {
  const BikeAndCarServices({Key? key}) : super(key: key);

  @override
  _BikeAndCarServicesState createState() => _BikeAndCarServicesState();
}

class _BikeAndCarServicesState extends State<BikeAndCarServices> {
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
