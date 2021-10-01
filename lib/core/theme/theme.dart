import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData.light();

  static final dark = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.red,
    ),
  );
}
