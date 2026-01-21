import 'package:flutter/material.dart';
import 'package:learning/core/theme/app_pallete.dart';

class AppTheme {
  static OutlineInputBorder _border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }

  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      filled: true,
      fillColor: AppPallete.whiteColor,
      enabledBorder: _border(AppPallete.borderColor),
      focusedBorder: _border(Colors.black, 3),
      errorBorder: _border(AppPallete.errorColor),
      focusedErrorBorder: _border(AppPallete.errorColor, 3),
    ),
  );
}
