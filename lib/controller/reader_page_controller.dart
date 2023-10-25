import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Api/adapter.dart';
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
    required MangaApiAdapter api,
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
                  api: api,
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
    required MangaApiAdapter api,
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
                  api: api,
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

  static pageControllerListener({
    required Future<List<String>> imageUrls,
    required PageController pageController,
    required BuildContext context,
    required MangaBuilder builder,
    required List<Chapter> chapters,
    required int chapterIndex,
    required Axis axis,
    required Widget icon,
    required bool reverse,
    required MangaApiAdapter api,
    required Function(MangaBuilder) onScope,
    required Function(int page, int chapterIndex) onPageChange,
  }) {
    onPageChange(pageController.page!.toInt(), (chapters.length - chapterIndex) - 1);
    imageUrls.then((images) {
      if (images.isNotEmpty) {
        if (pageController.page == images.length && chapterIndex - 1 >= 0) {
          ReaderPageController.nextChapter(
            context: context,
            builder: builder,
            chapterIndex: chapterIndex,
            axis: axis,
            icon: icon,
            reverse: reverse,
            onScope: onScope,
            onPageChange: onPageChange,
            api: api,
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
            api: api,
          );
        }
      }
    });
  }

  static void preload(BuildContext context, String path) {
    final configuration = createLocalImageConfiguration(context);
    CachedNetworkImageProvider(path).resolve(configuration);
  }
}
