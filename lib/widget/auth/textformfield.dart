import 'package:flutter/material.dart';
import 'package:bike_cafe/widget/config.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget(
      {Key? key,
      this.heading,
      this.type,
      this.onSaved,
      this.controller,
      this.initialValue,
      this.textalign})
      : super(key: key);
  final _formKey = GlobalKey<FormState>();
  String? heading;
  final TextInputType? type;
  final onSaved;
  final TextEditingController? controller;
  final initialValue;
  final textalign;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Container(
              decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: TextFormField(
                textAlign: textalign,
                controller: controller,
                initialValue: initialValue,
                onSaved: onSaved,
                keyboardType: type,
                decoration: InputDecoration(
                  hintText: heading,
                  hoverColor: Colors.black,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
