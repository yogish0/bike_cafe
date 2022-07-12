import 'package:flutter/material.dart';

import '../config.dart';

class RoundedTextFormField extends StatefulWidget {
  const RoundedTextFormField({
    Key? key,
    this.controller,
    this.onSaved,
    this.obsecureText = false,
    @required this.hintText,
    this.validator,
    this.type,
    this.textAlign
  }) : super(key: key);

  final TextEditingController? controller;
  final bool? obsecureText;
  final String? hintText;
  final onSaved;
  final validator;
  final TextInputType? type;
  final TextAlign? textAlign;

  @override
  State<RoundedTextFormField> createState() => _RoundedTextFormFieldState();
}

class _RoundedTextFormFieldState extends State<RoundedTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: containerColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30)),
      ),
      child: TextFormField(
        cursorColor: containerColor,
        controller: widget.controller,
        obscureText: widget.obsecureText! ,
        onSaved: widget.onSaved,
        keyboardType: widget.type,
        textAlign: widget.textAlign == null ? TextAlign.start : TextAlign.center,
        decoration: InputDecoration(
          hintText: widget.hintText!,
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: containerColor),
            borderRadius: const BorderRadius.all(
              const Radius.circular(30.0),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: containerColor),
            borderRadius: const BorderRadius.all(
              const Radius.circular(30.0),
            ),
          ),
          fillColor: containerColor,
          filled: true,
          errorBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: const BorderRadius.all(
              const Radius.circular(30.0),
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: const BorderRadius.all(
              const Radius.circular(30.0),
            ),
          ),
          contentPadding: EdgeInsets.all(20),
        ),
        validator: widget.validator,
      ),
    );
  }
}
// 8183005421

// rounded text field for password
class RoundedPassWordTextFormField extends StatefulWidget {
  RoundedPassWordTextFormField({
    Key? key,
    this.controller,
    this.onSaved,
    @required this.hintText,
    this.validator,
    this.type,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? hintText;
  final onSaved;
  final validator;
  final TextInputType? type;

  @override
  State<RoundedPassWordTextFormField> createState() => _RoundedPassWordTextFormFieldState();
}

class _RoundedPassWordTextFormFieldState extends State<RoundedPassWordTextFormField> {
  var visible = Icon(Icons.visibility,color: Colors.grey,);
  var visibleoff = Icon(Icons.visibility_off,color: Colors.grey,);
  bool isPassword = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: containerColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30)),
      ),
      child: TextFormField(
        cursorColor: containerColor,
        controller: widget.controller,
        obscureText: isPassword ,
        onSaved: widget.onSaved,
        keyboardType: widget.type,
        decoration: InputDecoration(
          hintText: widget.hintText!,
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: containerColor),
            borderRadius: const BorderRadius.all(
              const Radius.circular(30.0),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: containerColor),
            borderRadius: const BorderRadius.all(
              const Radius.circular(30.0),
            ),
          ),
          fillColor: containerColor,
          filled: true,
          errorBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: const BorderRadius.all(
              const Radius.circular(30.0),
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: containerColor),
            borderRadius: const BorderRadius.all(
              const Radius.circular(30.0),
            ),
          ),
          contentPadding: EdgeInsets.all(20),
          suffixIcon: GestureDetector(
            child: isPassword ? visible : visibleoff,
            onTap: (){
              setState(() {
                isPassword = !isPassword;
              });
            },
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
// 8183005421