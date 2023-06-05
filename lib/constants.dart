import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String baseUrl = "https://www.mangaworld.so";
const double defaultPadding = 16;
final navigatorKey = GlobalKey<NavigatorState>();

// * Text Style
TextStyle titleStyle({double? fontSize = 18}) {
  return GoogleFonts.sourceSansPro(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize);
}

TextStyle titleBlackStyle({double? fontSize = 18}) {
  return GoogleFonts.sourceSansPro(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: fontSize);
}

TextStyle titleGreenStyle({double? fontSize = 18}) {
  return GoogleFonts.sourceSansPro(
      color: greenColor, fontWeight: FontWeight.bold, fontSize: fontSize);
}

TextStyle subtitleStyle({double? fontSize = 14}) {
  return GoogleFonts.sourceSansPro(
      color: Colors.white, fontWeight: FontWeight.w300, fontSize: fontSize);
}

TextStyle miniStyle({double? fontSize = 12}) {
  return GoogleFonts.sourceSansPro(color: Colors.white, fontSize: fontSize);
}

const backgroundColor = Color(0xffe5f0f4);
const primaryColor = Colors.teal;
const secondaryColor = Color(0xff7bc496);

const blueColor = Color(0xff85a4e7);
const purpleColor = Color(0xffb084d1);
const redColor = Color(0xffd17db8);
const greenColor = Color(0xff4ba2b6);
