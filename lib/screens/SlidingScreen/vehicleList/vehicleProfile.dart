import 'package:flutter/material.dart';
import 'package:bike_cafe/services/api.dart';

class VechileProfile extends StatefulWidget {
  VechileProfile({Key? key}) : super(key: key);

  @override
  State<VechileProfile> createState() => _VechileProfileState();
}

class _VechileProfileState extends State<VechileProfile> {
  APIService service = APIService();

  @override
  Widget build(BuildContext context) {
    return Column(children: []);
  }
}