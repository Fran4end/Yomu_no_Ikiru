import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yomu_no_ikiru/core/theme/old/old_palette.dart';

class OldTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      elevation: 5,
      centerTitle: true,
      titleTextStyle: TextStyle(color: Color(0xff0D0D0D), fontSize: 28),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      elevation: 5,
      backgroundColor: Colors.black54,
      labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xffF78C25),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 20,
      contentTextStyle: GoogleFonts.robotoCondensed(fontSize: 28),
    ),
    colorScheme: const ColorScheme.light(
      surface: Color(0xfff6f5f5),
      primary: Color(0xffF78C25),
      secondary: Color(0xff9f5023),
      tertiary: Color(0xffF78C25),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffF78C25),
        alignment: Alignment.center,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledBackgroundColor: const Color(0x33f6f5f5),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      elevation: 5,
      color: OldPalette.backgroundColor,
      centerTitle: true,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 28),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      elevation: 5,
      backgroundColor: OldPalette.backgroundColor,
      labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    ),
    // snackBarTheme: SnackBarThemeData(
    //   backgroundColor: const Color(0xff005B41),
    //   behavior: SnackBarBehavior.floating,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //   elevation: 20,
    //   contentTextStyle: GoogleFonts.robotoCondensed(fontSize: 28),
    // ),
    colorScheme: const ColorScheme.dark(
      surface: OldPalette.backgroundColor,
      primary: OldPalette.gradient1,
      secondary: OldPalette.gradient2,
      tertiary: OldPalette.gradient3,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: OldPalette.gradient1,
        alignment: Alignment.center,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledBackgroundColor: const Color(0xff232D3F),
      ),
    ),
  );
}
