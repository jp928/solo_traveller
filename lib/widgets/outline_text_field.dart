import 'package:flutter/material.dart';
import 'package:solo_traveller/constants/colors.dart';

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
                width: 1.6,
                color:
                  // Color.fromRGBO(218, 218, 236, 1)
                  placeholderGrey
                )
          ),
        focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(
                color:
                  Color.fromRGBO(79, 152, 248, 1)
                )
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: placeholderGrey
        )
      ),
      validator: this.validator,
      autocorrect: false,
      obscureText: true,
    );
  }
}