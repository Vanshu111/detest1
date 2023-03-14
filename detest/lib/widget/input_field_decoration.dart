import 'package:flutter/material.dart';
import '../constant.dart';

InputDecoration inputDecoration(String lable, IconData icon) {
  return InputDecoration(
    labelText: lable,
    prefixIcon: Icon(icon),
    labelStyle: const TextStyle(fontSize: 20),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(
        color: borderColor,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(
        color: borderColor,
      ),
    ),
  );
}
