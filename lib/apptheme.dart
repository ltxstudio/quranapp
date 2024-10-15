import 'package:flutter/material.dart';

class AppTheme {
  static const Color _lightScaffoldBackgroundColor = Colors.white;
  static const Color _darkScaffoldBackgroundColor = Color(0xFF2F4F7F);

  static ThemeData light() {
    return ThemeData(
      primaryColor: const Color(0xFF7BC8F6),
      scaffoldBackgroundColor: _lightScaffoldBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF7BC8F6),
        foregroundColor: Colors.black,
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 24, color: Colors.black),
        headline2: TextStyle(fontSize: 20, color: Colors.black),
        headline3: TextStyle(fontSize: 18, color: Colors.black),
        bodyText1: TextStyle(fontSize: 16, color: Colors.black),
        bodyText2: TextStyle(fontSize: 14, color: Colors.black),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      primaryColor: const Color(0xFF2F4F7F),
      scaffoldBackgroundColor: _darkScaffoldBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2F4F7F),
        foregroundColor: Colors.white,
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 24, color: Colors.white),
        headline2: TextStyle(fontSize: 20, color: Colors.white),
        headline3: TextStyle(fontSize: 18, color: Colors.white),
        bodyText1: TextStyle(fontSize: 16, color: Colors.white),
        bodyText2: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }
}
