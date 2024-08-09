import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yomu_no_ikiru/Api/adapter.dart';

import '../../../model/chapter.dart';
import '../../../controller/reader_page_controller.dart';
import '../../../model/manga.dart';

class ReaderBottomNavigationBar extends StatelessWidget {
  final bool reverse;
  final List<Chapter> chapters;
  final Manga manga;
  final int chapterIndex;
  final Axis axis;
  final Widget icon;
  final Slider slider;
  final MangaApiAdapter api;
  final List<String> images;
  final int pageIndex;
  final PageController pageController1;
  final Function(Manga) onScope;
  final Function(int page, int chapterIndex) onPageChange;

  const ReaderBottomNavigationBar({
    super.key,
    required this.reverse,
    required this.chapters,
    required this.manga,
    required this.chapterIndex,
    required this.axis,
    required this.icon,
    required this.onScope,
    required this.images,
    required this.pageIndex,
    required this.onPageChange,
    required this.api,
    required this.slider,
    required this.pageController1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton.filled(
          icon: const Icon(FontAwesomeIcons.backwardStep),
          style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                fixedSize: const MaterialStatePropertyAll(Size(20, 20)),
              ),
          tooltip: !reverse ? "Previous chapter" : "Next chapter",
          onPressed: reverse
              ? chapterIndex - 1 >= 0
                  ? () => ReaderPageController.nextChapter(
                        pageController1: pageController1,
                        context: context,
                        manga: manga,
                        chapterIndex: chapterIndex,
                        axis: axis,
                        icon: icon,
                        reverse: reverse,
                        onScope: onScope,
                        onPageChange: onPageChange,
                        api: api,
                      )
                  : null
              : chapterIndex + 1 < chapters.length
                  ? () => ReaderPageController.previousChapter(
                        pageController1: pageController1,
                        context: context,
                        manga: manga,
                        chapterIndex: chapterIndex,
                        axis: axis,
                        icon: icon,
                        reverse: reverse,
                        onScope: onScope,
                        onPageChange: onPageChange,
                        api: api,
                      )
                  : null,
        ),
        Expanded(
          child: Directionality(
            textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
            child: Container(
              margin: const EdgeInsets.only(bottom: 1, left: 5, right: 5),
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xff2a2a2a),
                borderRadius: BorderRadius.circular(20),
              ),
              child: slider,
            ),
          ),
        ),
        IconButton.filled(
          onPressed: !reverse
              ? chapterIndex - 1 >= 0
                  ? () => ReaderPageController.nextChapter(
                        pageController1: pageController1,
                        context: context,
                        manga: manga,
                        chapterIndex: chapterIndex,
                        axis: axis,
                        icon: icon,
                        reverse: reverse,
                        onScope: onScope,
                        onPageChange: onPageChange,
                        api: api,
                      )
                  : null
              : chapterIndex + 1 < chapters.length
                  ? () => ReaderPageController.previousChapter(
                        pageController1: pageController1,
                        context: context,
                        manga: manga,
                        chapterIndex: chapterIndex,
                        axis: axis,
                        icon: icon,
                        reverse: reverse,
                        onScope: onScope,
                        onPageChange: onPageChange,
                        api: api,
                      )
                  : null,
          tooltip: reverse ? "Previous chapter" : "Next chapter",
          icon: const Icon(FontAwesomeIcons.forwardStep),
          style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                fixedSize: const MaterialStatePropertyAll(Size(20, 20)),
              ),
        ),
      ],
    );
  }
}
