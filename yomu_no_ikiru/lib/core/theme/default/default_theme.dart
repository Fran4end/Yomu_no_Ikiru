import 'package:flutter/material.dart';
import 'package:yomu_no_ikiru/core/theme/default/default_palette.dart';

class DefaultTheme {
  static _border([Color color = DefaultPalette.borderColor]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(30),
      );

  static final darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: DefaultPalette.gradient4,
      surface: DefaultPalette.backgroundColor,
      primary: DefaultPalette.gradient1,
      secondary: DefaultPalette.gradient2,
      tertiary: DefaultPalette.gradient3,
      error: DefaultPalette.errorColor,
      outline: DefaultPalette.borderColor,
      inverseSurface: DefaultPalette.transparentColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: DefaultPalette.transparentColor,
      foregroundColor: DefaultPalette.whiteColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DefaultPalette.gradient4,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: DefaultPalette.gradient1.withAlpha(160)),
      filled: true,
      fillColor: DefaultPalette.gradient2,
      contentPadding: const EdgeInsets.only(
        left: 20,
        bottom: 10,
        top: 10,
      ),
      enabledBorder: _border(),
      focusedBorder: _border(DefaultPalette.gradient4),
      errorBorder: _border(DefaultPalette.errorColor),
    ),
  );

//TODO: create a palette for light theme
  static final lightTheme = ThemeData.light(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: DefaultPalette.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DefaultPalette.gradient4.withAlpha(90),
      contentPadding: const EdgeInsets.only(
        left: 20,
        bottom: 10,
        top: 10,
      ),
      enabledBorder: _border(),
      focusedBorder: _border(DefaultPalette.gradient2),
      errorBorder: _border(DefaultPalette.errorColor),
    ),
  );
}
