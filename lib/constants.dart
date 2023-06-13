import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'model/rive_assets.dart';

const String baseUrl = "https://www.mangaworld.so";
const double defaultPadding = 16;
final navigatorKey = GlobalKey<NavigatorState>();
final List<RiveAsset> bottomNavigators = [
  RiveAsset("assets/RiveAssets/icons.riv",
      artboard: "HOME", stateMachineName: "HOME_interactivity", title: "Home"),
  RiveAsset("assets/RiveAssets/icons.riv",
      artboard: "SEARCH", stateMachineName: "SEARCH_Interactivity", title: "Search"),
  RiveAsset("assets/RiveAssets/icons.riv",
      artboard: "LIKE/STAR", stateMachineName: "STAR_Interactivity", title: "Library"),
  RiveAsset("assets/RiveAssets/icons.riv",
      artboard: "USER", stateMachineName: "USER_Interactivity", title: "Account"),
];

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  textTheme: GoogleFonts.sourceCodeProTextTheme(),
  appBarTheme: const AppBarTheme(
    elevation: 5,
    color: Colors.black54,
    centerTitle: true,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 28),
  ),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 5,
    backgroundColor: Colors.black54,
    labelTextStyle:
        MaterialStateProperty.all(const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
  ),
  colorScheme: const ColorScheme.light(
    background: Color(0xfff6f5f5),
    primary: Color(0xff9f5023),
    secondary: Color(0xffF78C25),
    tertiary: Color(0xffF78C25),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      alignment: Alignment.center,
      iconSize: MaterialStateProperty.all(35),
      textStyle: MaterialStateProperty.all(
        GoogleFonts.sourceSansPro(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 14),
      ),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  textTheme: GoogleFonts.sourceCodeProTextTheme(Typography.whiteCupertino),
  appBarTheme: const AppBarTheme(
    elevation: 5,
    color: Color(0xff2d2d2d),
    centerTitle: true,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 28),
  ),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 5,
    backgroundColor: const Color(0xff2d2d2d),
    labelTextStyle:
        MaterialStateProperty.all(const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: const Color(0xff9F5023),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 20,
    contentTextStyle: GoogleFonts.robotoCondensed(fontSize: 28),
  ),
  colorScheme: const ColorScheme.dark(
    background: Color(0xff0D0D0D),
    primary: Color(0xff9F5023),
    secondary: Color(0xffD96A29),
    tertiary: Color(0xffB8672F),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xff0D0D0D),
    size: 20,
    opacity: 1,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xffD96A29),
      alignment: Alignment.center,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      disabledBackgroundColor: const Color(0xffB8672F),
      textStyle: GoogleFonts.sourceSansPro(
          color: const Color(0xff0D0D0D), fontWeight: FontWeight.w300, fontSize: 14),
    ),
  ),
);

// * Text Style
// TextStyle titleStyle({double? fontSize = 18}) {
//   return GoogleFonts.sourceSansPro(
//       color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize);
// }

// TextStyle titleBlackStyle({double? fontSize = 18}) {
//   return GoogleFonts.sourceSansPro(
//       color: Colors.black, fontWeight: FontWeight.bold, fontSize: fontSize);
// }

// TextStyle titleGreenStyle({double? fontSize = 18}) {
//   return GoogleFonts.sourceSansPro(
//       color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize);
// }

// TextStyle subtitleStyle({double? fontSize = 14, FontWeight fontWeight = FontWeight.w300}) {
//   return GoogleFonts.sourceSansPro(color: Colors.white, fontWeight: fontWeight, fontSize: fontSize);
// }

// TextStyle miniStyle({double? fontSize = 12, Color color = Colors.white}) {
//   return GoogleFonts.sourceSansPro(color: color, fontSize: fontSize);
// }
