import 'package:flutter/material.dart';
import 'package:detest/constant.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isObscure;
  final IconData icon;
  final String initalvalue;
  // final String initalvalue;
  const TextInputField(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.initalvalue,
      this.isObscure = false,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      // controller: controller,
      controller: controller..text = initalvalue,
      decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon),
          labelStyle: const TextStyle(fontSize: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: buttonColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: buttonColor,
            ),
          )),
      obscureText: isObscure,
    );
  }
}
