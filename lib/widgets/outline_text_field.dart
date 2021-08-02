import 'package:flutter/material.dart';

class OutlineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  OutlineTextField({
    required this.controller,
    required this.hintText,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: new BorderSide(
                color: Color.fromRGBO(
                    218, 218, 236, 1))),
        focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(
                color: Color.fromRGBO(
                    79, 152, 248, 1))),
        hintText: hintText,
      ),
      validator: this.validator,
      autocorrect: false,
      obscureText: true,
    );
  }
}