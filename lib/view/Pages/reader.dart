import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yomu_no_ikiru/model/manga_builder.dart';
import 'package:yomu_no_ikiru/view/widgets/Reader%20Page%20Widgets/reader_page_widget.dart';

import '../../Api/adapter.dart';
import '../../controller/reader_page_controller.dart';
import '../../model/chapter.dart';
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
  final MangaBuilder manga;
  final MangaApiAdapter api;
  final Function(Manga manga) onScope;
  final Function(int, int) onPageChange;

  @override
  State<StatefulWidget> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  late final MangaBuilder manga = widget.manga;
  late int chapterIndex = widget.chapterIndex;
  late MangaApiAdapter api = widget.api;
  late Chapter currentChap = manga.chapters[chapterIndex];
  late final WebViewController controller;
  late final PageController pageController = PageController(
    initialPage: widget.pageIndex,
  );

  SplayTreeMap pages = SplayTreeMap<int, List>((a, b) => a.compareTo(b));
  List<PhotoViewGalleryPageOptions> chapterPages = [];
  bool showAppBar = false;

  bool isSliding = false;
  double sliderValue = 2;
  int oldIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
    _loadChapter(currentChap.link);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    widget.onScope(manga.build());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pageController.addListener(
      () => ReaderPageController.pageControllerListener(
        chapterIndex: chapterIndex,
        loadNext: () {
          chapterIndex--;
          currentChap = manga.chapters[chapterIndex];
          _loadChapter(currentChap.link);
          setState(() {});
        },
        loadPrev: () {
          chapterIndex++;
          currentChap = manga.chapters[chapterIndex];
          _loadChapter(currentChap.link);
          setState(() {});
        },
        manga: manga.build(),
        onPageChange: widget.onPageChange,
        currentPage: sliderValue.toInt() - 2,
      ),
    );
    return chapterPages.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Builder(builder: (context) {
            List<PhotoViewGalleryPageOptions> allPages = [];
            for (var chapPages in pages.values) {
              allPages.addAll(chapPages);
            }
            return Scaffold(
              body: GestureDetector(
                onTap: () {
                  ReaderPageController.onTap(showAppBar: showAppBar);
                },
                child: ReaderPageWidget(
                  axis: Axis.horizontal,
                  reverse: true,
                  pageController: pageController,
                  onPageChanged: (index) {},
                  pages: allPages,
                ),
              ),
            );
          });
  }

  _loadChapter(String link) {
    ReaderPageController.loadChapter(
      onFinish: (urls) {
        final imageUrls = urls;
        chapterPages = ReaderPageController.buildPages(
          chapters: manga.chapters,
          chapterIndex: chapterIndex,
          imageUrls: imageUrls,
        );
        pages.addAll(<int, List>{chapterIndex: chapterPages});
        currentChap.nPages = urls.length;
        manga.chapters[chapterIndex] = currentChap;
        setState(() {});
      },
      link: link,
      controller: controller,
      api: api,
    );
  }
}
