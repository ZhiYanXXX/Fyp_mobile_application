import 'package:flutter/material.dart';
import 'package:medapp/constant/colors.dart';

class MTextFormFieldTheme {
  MTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme =
      const InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100))),
          prefixIconColor: mSecondaryColor,
          floatingLabelStyle: TextStyle(color: mSecondaryColor),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(width: 3, color: mSecondaryColor)));

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
      prefixIconColor: mPrimaryColor,
      floatingLabelStyle: const TextStyle(color: mPrimaryColor),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: mPrimaryColor)));
}
