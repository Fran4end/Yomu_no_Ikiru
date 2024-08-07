import 'package:flutter/material.dart';
import 'package:yomu_no_ikiru/view/widgets/Reader%20Page%20Widgets/reader_chapter_page.dart';
import 'package:yomu_no_ikiru/view/widgets/Reader%20Page%20Widgets/reader_direction_icon.dart';

import '../../Api/adapter.dart';
import '../../model/manga.dart';

class Reader extends StatefulWidget {
  const Reader({
    super.key,
    required this.chapterIndex,
    required this.manga,
    required this.onScope,
    required this.api,
    required this.onPageChange,
    required this.pageIndex,
  });

  final int chapterIndex, pageIndex;
  final Manga manga;
  final MangaApiAdapter api;
  final Function(Manga manga) onScope;
  final Function(int, int) onPageChange;

  @override
  State<StatefulWidget> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  late final Manga manga = widget.manga;
  late int chapterIndex = widget.chapterIndex;

  PageController pageController = PageController();
  List<ReaderChapterPage> chapterPages = [];
  int nChapters = 1;

  @override
  void initState() {
    chapterPages.add(
      ReaderChapterPage(
        pageController1: pageController,
        chapterIndex: chapterIndex,
        pageIndex: widget.pageIndex,
        manga: manga,
        onScope: widget.onScope,
        axis: Axis.horizontal,
        reverse: true,
        icon: const RightLeftIcon(),
        onPageChange: widget.onPageChange,
        api: widget.api,
        onLastPage: _onLastPage,
        onFirstPage: _onFirstPage,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemCount: (nChapters + 2) + (nChapters - 1),
        itemBuilder: (context, index) {
          if (index % 2 == 0) {
            return const Center(child: Text("intermezzo"));
          } else {
            return Center(child: chapterPages[(index ~/ 2)]);
          }
        },
      ),
    );
  }

  _onLastPage(int newChapterIndex) {
    chapterIndex = newChapterIndex;
    chapterPages.insert(
      chapterPages.length - 1,
      ReaderChapterPage(
        pageController1: pageController,
        chapterIndex: chapterIndex,
        pageIndex: widget.pageIndex,
        manga: manga,
        onScope: widget.onScope,
        axis: Axis.horizontal,
        reverse: true,
        icon: const RightLeftIcon(),
        onPageChange: widget.onPageChange,
        api: widget.api,
        onLastPage: _onLastPage,
        onFirstPage: _onFirstPage,
      ),
    );
    setState(() {});
  }

  _onFirstPage(int newChapterIndex) {}
}
