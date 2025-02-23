import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final appTheme = ThemeData(
  // Define the default brightness and colors.
  colorScheme: ColorScheme.fromSeed(
    seedColor: onSecondary,
    primary: onSecondary,
    onPrimary: colorOnPrimary,
    primaryContainer: primaryColor,
    secondaryContainer: secondaryColor,
    secondary: colorOnPrimary,
    onSecondary: onSecondary,
    errorContainer: secondaryColor,brightness: Brightness.light,
    error: Colors.red,
  ),

  textTheme: TextTheme(
    displayLarge: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
    titleLarge: GoogleFonts.oswald(fontSize: 30, fontStyle: FontStyle.italic),
    bodyMedium: GoogleFonts.merriweather(),
    displaySmall: GoogleFonts.pacifico(),
  ),
);

final primaryColor = Color.fromRGBO(228, 227, 200, 1.0);
final colorOnPrimary = Color.fromRGBO(54, 97, 40, 1.0);
final secondaryColor = Color.fromRGBO(224, 175, 61, 1.0);
final onSecondary = Color.fromRGBO(240, 136, 51, 1.0);
final defaultBlack = Colors.black;
