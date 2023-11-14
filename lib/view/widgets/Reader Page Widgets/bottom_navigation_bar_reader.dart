import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yomu_no_ikiru/Api/adapter.dart';
import 'package:yomu_no_ikiru/model/manga_builder.dart';

import '../../../model/chapter.dart';
import '../../../constants.dart';
import '../../../controller/reader_page_controller.dart';

class ReaderBottomNavigationBar extends StatelessWidget {
  final bool reverse;
  final List<Chapter> chapters;
  final MangaBuilder builder;
  final int chapterIndex;
  final Axis axis;
  final Widget icon;
  final Slider? slider;
  final MangaApiAdapter api;
  final List<String> images;
  final int pageIndex;
  final Function(MangaBuilder) onScope;
  final Function(int page, int chapterIndex) onPageChange;

  const ReaderBottomNavigationBar({
    required this.reverse,
    required this.chapters,
    required this.builder,
    required this.chapterIndex,
    required this.axis,
    required this.icon,
    required this.onScope,
    required this.images,
    required this.pageIndex,
    required this.onPageChange,
    required this.api,
    this.slider,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: defaultPadding / 2,
        left: defaultPadding / 2,
        right: defaultPadding / 2,
        bottom: defaultPadding,
      ),
      child: Row(
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
                          context: context,
                          builder: builder,
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
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(pageIndex.toString()),
                      Expanded(
                        child: slider ?? const Center(),
                      ),
                      Text((images.length + 1).toString()),
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton.filled(
            onPressed: !reverse
                ? chapterIndex - 1 >= 0
                    ? () => ReaderPageController.nextChapter(
                        context: context,
                        builder: builder,
                        chapterIndex: chapterIndex,
                        axis: axis,
                        icon: icon,
                        reverse: reverse,
                        onScope: onScope,
                        onPageChange: onPageChange,
                        api: api)
                    : null
                : chapterIndex + 1 < chapters.length
                    ? () => ReaderPageController.previousChapter(
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
                        )
                    : null,
            tooltip: reverse ? "Previous chapter" : "Next chapter",
            icon: const Icon(FontAwesomeIcons.forwardStep),
            style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                  fixedSize: const MaterialStatePropertyAll(Size(20, 20)),
                ),
          ),
        ],
      ),
    );
  }
}
