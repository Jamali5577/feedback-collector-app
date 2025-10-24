
import 'package:feedback_collector_app/Utils/typ_def.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constant/colors.dart';




class textFieldWithIconWidget extends StatefulWidget {
  textFieldWithIconWidget(
      {super.key,
        required this.widgetcontroller,
        required this.validatorCallback,
        required this.fieldName,
        this.widgeticon,
        required  this.isPasswordField,
        this.keyboardtype,
      });

  //SETTING THE PARAMETER FOR THE widgets
  TextEditingController widgetcontroller = TextEditingController();
  IconData? widgeticon;
 final ValidatorCallback validatorCallback;
  String fieldName = "sample";
  bool isPasswordField = false;
  TextInputType? keyboardtype = TextInputType.text;

  @override
  State<textFieldWithIconWidget> createState() => TextFieldWithIconWidgetState();
}

class TextFieldWithIconWidgetState extends State<textFieldWithIconWidget> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      shadowColor: darkGreenColor.withOpacity(0.3),
      child: TextFormField(
        obscureText: widget.isPasswordField
            ? showPassword
            ? false
            : true
            : false,
        scrollPhysics: const BouncingScrollPhysics(),
        keyboardType: widget.keyboardtype,
        controller: widget.widgetcontroller,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.widgeticon),
            suffixIcon: widget.isPasswordField
                ? GestureDetector(
                onTap: () {
                  setState(() {
                    showPassword = showPassword ? false : true;
                  });
                },
                child: Icon(showPassword
                    ? CupertinoIcons.eye_slash_fill
                    : CupertinoIcons.eye_fill))
                : const IgnorePointer(),
            hintText: widget.fieldName,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey, width: 1))
          //label: Text(widget.fieldName),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter your ${widget.fieldName}";
          }
          return null;
        },
      ),
    );
  }
}
