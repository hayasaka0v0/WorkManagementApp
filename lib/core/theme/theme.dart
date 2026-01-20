import 'package:flutter/material.dart';
import 'package:learning/core/theme/app_pallete.dart';

class AppTheme {
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(vertical: 12.0), 
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppPallete.greyColor, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppPallete.whiteColor, width: 1.0),
      ),
    ),
  );
}
