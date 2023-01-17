import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String baseUrl = "https://www.mangaworld.so";
const double defaultPadding = 16;
final navigatorKey = GlobalKey<NavigatorState>();

// * Text Style
TextStyle titleStyle({double fontsize = 18}) {
  return GoogleFonts.sourceSansPro(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontsize);
}

TextStyle titleBlackStyle({double fontsize = 18}) {
  return GoogleFonts.sourceSansPro(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: fontsize);
}

TextStyle titleGreenStyle({double fontsize = 18}) {
  return GoogleFonts.sourceSansPro(
      color: greenColor, fontWeight: FontWeight.bold, fontSize: fontsize);
}

TextStyle subtitleStyle({double fontsize = 14}) {
  return GoogleFonts.sourceSansPro(
      color: Colors.white, fontWeight: FontWeight.w300, fontSize: fontsize);
}

TextStyle miniStyle({double fontsize = 12}) {
  return GoogleFonts.sourceSansPro(color: Colors.white, fontSize: 12);
}

const backgroundColor = Color(0xffe5f0f4);
const primaryColor = Colors.teal;
const secondaryColor = Color(0xff7bc496);

const blueColor = Color(0xff85a4e7);
const purpleColor = Color(0xffb084d1);
const redColor = Color(0xffd17db8);
const greenColor = Color(0xff4ba2b6);
