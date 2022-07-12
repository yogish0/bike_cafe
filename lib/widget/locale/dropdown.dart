import 'package:flutter/material.dart';
import 'package:bike_cafe/widget/config.dart';

class DropDownButtonList extends StatefulWidget {
  DropDownButtonList({Key? key, this.names, this.hinttext}) : super(key: key);

  List? names;
  String? hinttext;

  @override
  _DropDownButtonListState createState() => _DropDownButtonListState();
}

class _DropDownButtonListState extends State<DropDownButtonList> {
  String? valueChoose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 60,
        decoration: BoxDecoration(
            color: containerColor,
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: Center(
          child: DropdownButton(
            icon: Icon(Icons.arrow_drop_down_circle_outlined),
            iconSize: 30,
            isExpanded: true,
            underline: SizedBox(),
            hint: Text(widget.hinttext.toString()),
            value: valueChoose,
            onChanged: (newValue) {
              setState(() {
                valueChoose = newValue as String?;
              });
            },
            items: widget.names!.map((valueItem) {
              return DropdownMenuItem(child: Text(valueItem), value: valueItem);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
