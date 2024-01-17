import 'package:flutter/material.dart';
import 'package:medapp/constant/colors.dart';
import 'package:medapp/constant/sizes.dart';

class MOutlinedButtonTheme {
  MOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(),
      foregroundColor: mSecondaryColor,
      side: const BorderSide(color: mSecondaryColor),
      padding: const EdgeInsets.symmetric(vertical: mButtonHeight),
    ),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(),
      foregroundColor: mWhiteColor,
      side: const BorderSide(color: mWhiteColor),
      padding: const EdgeInsets.symmetric(vertical: mButtonHeight),
    ),
  );
}
