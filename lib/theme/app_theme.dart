import 'package:flutter/material.dart';

class AppTheme {
  // Couleur principale - Vert emeraude UIN
  static const Color primary = Color(0xFF00855A);
  static const Color primaryDark = Color(0xFF006440);
  static const Color primaryLight = Color(0xFF00A86B);

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      fontFamily: 'Roboto',
    );
  }
}