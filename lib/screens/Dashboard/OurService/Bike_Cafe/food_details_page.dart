import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Food_details extends StatefulWidget {
  const Food_details({Key? key}) : super(key: key);

  @override
  _Food_detailsState createState() => _Food_detailsState();
}

class _Food_detailsState extends State<Food_details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
