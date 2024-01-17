import 'package:flutter/material.dart';
import 'package:medapp/utils/theme/widget_theme/appbar_theme.dart';
import 'package:medapp/utils/theme/widget_theme/elevated_button_theme.dart';
import 'package:medapp/utils/theme/widget_theme/outlined_button_theme.dart';
import 'package:medapp/utils/theme/widget_theme/text_field_theme.dart';
import 'package:medapp/utils/theme/widget_theme/text_theme.dart';

class AppTheme {
  AppTheme._();
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: const Color.fromARGB(255, 250, 243, 222),
      appBarTheme: MAppBarTheme.lightAppBarTheme,
      brightness: Brightness.light,
      textTheme: MTextTheme.lightTextTheme,
      elevatedButtonTheme: MElevatedButtonTheme.lightElevatedButtonTheme,
      outlinedButtonTheme: MOutlinedButtonTheme.lightOutlinedButtonTheme,
      inputDecorationTheme: MTextFormFieldTheme.lightInputDecorationTheme);

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      textTheme: MTextTheme.darkTextTheme,
      elevatedButtonTheme: MElevatedButtonTheme.darkElevatedButtonTheme,
      outlinedButtonTheme: MOutlinedButtonTheme.darkOutlinedButtonTheme,
      inputDecorationTheme: MTextFormFieldTheme.darkInputDecorationTheme);
}
