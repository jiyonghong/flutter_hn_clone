import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  textTheme: TextTheme(
    headlineLarge: TextStyle(fontFamily: 'Domine', fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(
      fontFamily: 'Domine',
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(fontFamily: 'Domine', fontWeight: FontWeight.w600),
  ),
  colorScheme: .fromSeed(seedColor: Colors.blue),
);

ThemeData darkTheme = ThemeData(
  textTheme: TextTheme(
    headlineLarge: TextStyle(fontFamily: 'Domine', fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(
      fontFamily: 'Domine',
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(fontFamily: 'Domine', fontWeight: FontWeight.w600),
  ),
  colorScheme: .fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
);
