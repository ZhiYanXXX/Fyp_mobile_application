import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medapp/constant/colors.dart';

class MTextTheme {
  MTextTheme._();
  static TextTheme lightTextTheme = TextTheme(
      displayLarge: GoogleFonts.montserrat(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: mDarkColor,
      ),
      displayMedium: GoogleFonts.montserrat(
          fontSize: 24.0, fontWeight: FontWeight.w700, color: mDarkColor),
      displaySmall: GoogleFonts.poppins(
          fontSize: 24.0, fontWeight: FontWeight.w700, color: mDarkColor),
      headlineMedium: GoogleFonts.poppins(
          fontSize: 16.0, fontWeight: FontWeight.w600, color: mDarkColor),
      titleLarge: GoogleFonts.poppins(
          fontSize: 14.0, fontWeight: FontWeight.w600, color: mDarkColor),
      bodyLarge: GoogleFonts.poppins(
          fontSize: 14.0, fontWeight: FontWeight.normal, color: mDarkColor),
      bodyMedium: GoogleFonts.poppins(
          fontSize: 14.0, fontWeight: FontWeight.normal, color: mDarkColor),
      titleSmall: GoogleFonts.poppins(
          fontSize: 12.0, fontWeight: FontWeight.normal, color: mDarkColor));
  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: mWhiteColor,
    ),
    displayMedium: GoogleFonts.montserrat(
        fontSize: 24.0, fontWeight: FontWeight.w700, color: mWhiteColor),
    displaySmall: GoogleFonts.poppins(
        fontSize: 24.0, fontWeight: FontWeight.w700, color: mWhiteColor),
    headlineMedium: GoogleFonts.poppins(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: mWhiteColor),
    titleLarge: GoogleFonts.poppins(
        fontSize: 14.0, fontWeight: FontWeight.w600, color: mWhiteColor),
    bodyLarge: GoogleFonts.poppins(
        fontSize: 14.0, fontWeight: FontWeight.normal, color: mWhiteColor),
    bodyMedium: GoogleFonts.poppins(
        fontSize: 14.0, fontWeight: FontWeight.normal, color: mWhiteColor),
  );
}
