import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/dom.dart' as dom;

import '../model/manga_builder.dart';
import '../model/chapter.dart';
import '../view/Pages/reader_page.dart';

class ReaderPageController {
  static nextChapter({
    required BuildContext context,
    required MangaBuilder builder,
    required int chapterIndex,
    required Axis axis,
    required Widget icon,
    required bool reverse,
    required Function(MangaBuilder) onScope,
    required Function(int page, int chapterIndex) onPageChange,
  }) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => Reader(
                  chapter: builder.chapters[chapterIndex - 1],
                  pageIndex: 1,
                  builder: builder,
                  onScope: onScope,
                  axis: axis,
                  icon: icon,
                  reverse: reverse,
                  onPageChange: onPageChange,
                  chapterIndex: chapterIndex - 1,
                )));
  }

  static previousChapter({
    required BuildContext context,
    required MangaBuilder builder,
    required List<Chapter> chapters,
    required int chapterIndex,
    required Axis axis,
    required Widget icon,
    required bool reverse,
    required Function(MangaBuilder) onScope,
    required Function(int page, int chapterIndex) onPageChange,
  }) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => Reader(
                  chapter: chapters[chapterIndex + 1],
                  chapterIndex: chapterIndex + 1,
                  pageIndex: 1,
                  builder: builder,
                  onScope: onScope,
                  axis: axis,
                  icon: icon,
                  reverse: reverse,
                  onPageChange: onPageChange,
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

  static List<String> getImages({required dom.Document document}) {
    List<String> imageUrls = [];

    try {
      var elements = document.querySelectorAll('#page > img');
      for (var element in elements) {
        imageUrls.add(element.attributes['src']!);
      }
    } catch (e) {
      if (kDebugMode) {
        print('ReaderPageController Line 142: $e');
      }
    }

    return imageUrls;
  }

  static pageControllerListener({
    required List<String> imageUrls,
    required PageController pageController,
    required BuildContext context,
    required MangaBuilder builder,
    required List<Chapter> chapters,
    required int chapterIndex,
    required Axis axis,
    required Widget icon,
    required bool reverse,
    required Function(MangaBuilder) onScope,
    required Function(int page, int chapterIndex) onPageChange,
  }) {
    onPageChange(pageController.page!.toInt(), (chapters.length - chapterIndex) - 1);
    if (imageUrls.isNotEmpty) {
      if (pageController.page == imageUrls.length - 1 && chapterIndex - 1 >= 0) {
        ReaderPageController.nextChapter(
          context: context,
          builder: builder,
          chapterIndex: chapterIndex,
          axis: axis,
          icon: icon,
          reverse: reverse,
          onScope: onScope,
          onPageChange: onPageChange,
        );
      } else if (pageController.page == 0 && chapterIndex + 1 < chapters.length) {
        ReaderPageController.previousChapter(
          context: context,
          builder: builder,
          chapters: chapters,
          chapterIndex: chapterIndex,
          axis: axis,
          icon: icon,
          reverse: reverse,
          onScope: onScope,
          onPageChange: onPageChange,
        );
      }
    }
  }
}
