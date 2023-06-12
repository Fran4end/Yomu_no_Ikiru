import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:dio/dio.dart';

import '../model/manga_builder.dart';
import '../model/chapter.dart';
import '../view/Pages/reader_page.dart';

class ReaderPageController {
  static nextChapter({
    required BuildContext context,
    required MangaBuilder builder,
    required List<Chapter> chapters,
    required int index,
    required Axis axis,
    required Widget icon,
    required bool reverse,
    required Function(MangaBuilder) onScope,
  }) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => Reader(
                  chapter: chapters[index - 1],
                  chapters: chapters,
                  pageIndex: 0,
                  index: index - 1,
                  builder: builder,
                  onScope: onScope,
                  axis: axis,
                  icon: icon,
                  reverse: reverse,
                )));
  }

  static previousChapter({
    required BuildContext context,
    required MangaBuilder builder,
    required List<Chapter> chapters,
    required int index,
    required Axis axis,
    required Widget icon,
    required bool reverse,
    required Function(MangaBuilder) onScope,
  }) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => Reader(
                  chapter: chapters[index + 1],
                  chapters: chapters,
                  index: index + 1,
                  pageIndex: 0,
                  builder: builder,
                  onScope: onScope,
                  axis: axis,
                  icon: icon,
                  reverse: reverse,
                )));
  }

  static (Axis, Widget, bool) changeDirection({
    required Axis axis,
    required Widget icon,
    required bool reverse,
  }) {
    if (axis == Axis.vertical && reverse == false) {
      axis = Axis.horizontal;
      icon = Stack(
        alignment: Alignment.center,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Icon(FontAwesomeIcons.mobileScreenButton),
          ),
          Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(bottom: 2),
                child: const Icon(
                  FontAwesomeIcons.arrowRight,
                  size: 7,
                ),
              )),
        ],
      );
      reverse = false;
    } else if (reverse == false) {
      icon = Stack(
        alignment: Alignment.center,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Icon(FontAwesomeIcons.mobileScreenButton),
          ),
          Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(bottom: 2),
                child: const Icon(
                  FontAwesomeIcons.arrowLeft,
                  size: 7,
                ),
              )),
        ],
      );
      reverse = true;
    } else {
      axis = Axis.vertical;
      icon = Stack(
        alignment: Alignment.center,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Icon(FontAwesomeIcons.mobileScreenButton),
          ),
          Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(bottom: 2),
                child: const Icon(
                  FontAwesomeIcons.arrowDown,
                  size: 7,
                ),
              )),
        ],
      );
      reverse = false;
    }
    return (axis, icon, reverse);
  }

  static Future<List<String>> getImages({required Chapter chapter}) async {
    dom.Document document = await getChapter(chapter: chapter);
    List<String> imageUrls = [];

    try {
      var elements = document.querySelectorAll('#page > img');
      for (var element in elements) {
        imageUrls.add(element.attributes['src']!);
      }
    } catch (e, s) {
      if (kDebugMode) {
        print('$e: $s');
      }
    }

    return imageUrls;
  }

  static Future<dom.Document> getChapter({required Chapter chapter}) async {
    final response = await Dio().get(chapter.link!);
    dom.Document document = parse(response.data);

    return document;
  }
}
