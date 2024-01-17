import 'package:flutter/material.dart';

class MAppBarTheme {
  MAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    titleTextStyle: TextStyle(
        color: Color.fromARGB(255, 45, 34, 30),
        fontFamily: 'VarelaRound',
        fontSize: 24.0,
        fontWeight: FontWeight.bold),
    color: Colors.amber,
    shadowColor: Color.fromARGB(255, 249, 231, 164),
  );
}
