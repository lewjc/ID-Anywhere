import 'package:flutter/material.dart';

class IDAnywhereTextField extends StatelessWidget {
  IDAnywhereTextField({Key key, this.hint,
    this.validator, this.height = 50, this.width = 150,
    this.controller,
    this.passwordField = false}) : super(key: key);

  final String hint;
  
  final String Function(String) validator;

  final double height;

  final double width;

  final bool passwordField;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: this.width,
      height: this.height,
      child: TextFormField(
          controller: this.controller,
          validator: this.validator,
          obscureText: this.passwordField,
          style: TextStyle(            
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'Open Sans'),
          decoration: InputDecoration(
            errorStyle: TextStyle(color: Colors.yellowAccent),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
            errorBorder:  UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.yellowAccent),
            ),
            labelStyle: TextStyle(color: Colors.white),
            hintText: this.hint,
            hintStyle: TextStyle(color: Colors.white),
            fillColor: Colors.white,
            focusColor: Colors.white,
          )      
        ),
    );
  }
}
