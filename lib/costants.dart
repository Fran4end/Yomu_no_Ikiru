import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga_app/manga_builder.dart';

const String baseUrl = "https://www.mangaworld.so";
const double defaultPadding = 16;
Map<String, MangaBuilder> mangasBuilder = {};

// * Text Style
titleStyle() {
  return GoogleFonts.sourceSansPro(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17);
}

titleBlackStyle() {
  return GoogleFonts.sourceSansPro(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17);
}

titleGreenStyle() {
  return GoogleFonts.sourceSansPro(color: greenColor, fontWeight: FontWeight.bold, fontSize: 18);
}

subtitleStyle() {
  return GoogleFonts.sourceSansPro(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 14);
}

miniStyle() {
  return GoogleFonts.sourceSansPro(color: Colors.white, fontSize: 12);
}

// * App Colors
const backgroundColor = Color(0xffe5f0f4);
const primaryColor = Colors.teal;
const secondaryColor = Color(0xff7bc496);

// * Dashboard Color
const blueColor = Color(0xff85a4e7);
const purpleColor = Color(0xffb084d1);
const redColor = Color(0xffd17db8);
const greenColor = Color(0xff4ba2b6);

/*final ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromRGBO(168, 255, 219, 100),
  brightness: Brightness.dark,
  primary: const Color.fromRGBO(100, 179, 146, 70),
  secondary: const Color.fromRGBO(239, 194, 255, 100),
  tertiary: const Color.fromRGBO(255, 220, 143, 100),
);*/
