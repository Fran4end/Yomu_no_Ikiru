import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yomu_no_ikiru/constants.dart';
import 'package:yomu_no_ikiru/model/manga.dart';

import '../../../Api/adapter.dart';
import '../../../controller/reader_page_controller.dart';
import '../../../model/chapter.dart';
import 'animated_bar.dart';
import 'app_bar_reader_page.dart';
import 'bottom_navigation_bar_reader.dart';
import 'reader_page_widget.dart';

class ReaderChapterPage extends StatefulWidget {
  const ReaderChapterPage({
    this.showAppBar = false,
    super.key,
    required this.chapterIndex,
    required this.manga,
    required this.onScope,
    required this.axis,
    required this.reverse,
    required this.icon,
    required this.onPageChange,
    required this.api,
    required this.pageIndex,
    required this.pageController,
  });
  final int chapterIndex, pageIndex;
  final Manga manga;
  final Axis axis;
  final bool reverse, showAppBar;
  final Widget icon;
  final MangaApiAdapter api;
  final PageController pageController;
  final Function(Manga manga) onScope;
  final Function(int page, int chapterIndex) onPageChange;

  @override
  State<StatefulWidget> createState() => _ReaderState();
}

class _ReaderState extends State<ReaderChapterPage> {
  late final Function(Manga manga) onScope = widget.onScope;
  late final Manga manga = widget.manga;
  late final WebViewController controller;
  late final api = widget.api;
  late Chapter chapter;
  late int chapterIndex = widget.chapterIndex;
  late bool reverse = widget.reverse;
  late Axis axis = widget.axis;
  late Widget icon = widget.icon;
  late int pageIndex = widget.pageIndex;
  late PageController pageController = widget.pageController;
  late bool showAppBar = widget.showAppBar;

  List<String>? imageUrls;
  double sliderValue = 2;
  bool isSliding = false;
  double leftOverScroll = 0.0;
  double rightOverScroll = 0.0;

  @override
  void initState() {
    super.initState();
    chapter = manga.chapters[widget.chapterIndex];
    controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
    _loadChapter(chapter.link!);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  _loadChapter(String link) {
    ReaderPageController.loadChapter(
      onFinish: (urls) {
        imageUrls = urls;
        setState(() {});
      },
      link: link,
      controller: controller,
      api: api,
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    onScope(manga);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return imageUrls == null
        ? const Center(child: CircularProgressIndicator())
        : Builder(builder: (context) {
            pageController.addListener(() => ReaderPageController.pageControllerListener(
                  imageUrls: imageUrls!,
                  pageController: pageController,
                  manga: manga,
                  chapterIndex: chapterIndex,
                  onPageChange: widget.onPageChange,
                ));
            for (var img in imageUrls!) {
              ReaderPageController.preloadImage(context, img);
            }
        return Scaffold(
                appBar: AnimatedBar(
                  begin: const Offset(0, -1),
                  builder: () => !showAppBar
                      ? const SizedBox.shrink()
                      : ReaderPageAppBar(
                          chapter: chapter,
                          onPressed: () {
                            var (a, i, r) = ReaderPageController.changeDirection(
                                axis: axis, icon: icon, reverse: reverse);
                            axis = a;
                            icon = i;
                            reverse = r;
                            setState(() {});
                          },
                          mangaTitle: manga.title,
                          icon: icon,
                        ),
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: AnimatedBar(
                    begin: const Offset(0, 1),
                    builder: () => !showAppBar
                        ? const SizedBox.shrink()
                        : SafeArea(
                            child: ReaderBottomNavigationBar(
                              pageController1: pageController,
                              reverse: reverse,
                              chapters: manga.chapters,
                              manga: manga,
                              chapterIndex: widget.chapterIndex,
                              axis: axis,
                              icon: icon,
                              onScope: onScope,
                              onPageChange: widget.onPageChange,
                              images: imageUrls!,
                              pageIndex: pageIndex,
                              slider: Slider.adaptive(
                                inactiveColor: Theme.of(context).colorScheme.secondary,
                                value: sliderValue,
                                divisions: imageUrls!.length + 2,
                                label: "${sliderValue.toInt() - 1} / ${imageUrls!.length}",
                                min: 2,
                                max: (imageUrls!.length.toDouble() + 1),
                                onChangeStart: (value) => setState(() {
                                  isSliding = true;
                                }),
                                onChangeEnd: (value) => setState(() {
                                  isSliding = false;
                                }),
                                onChanged: (value) {
                                  if (!(value == 1 || value == imageUrls!.length + 2)) {
                                    sliderValue = value;
                                  }
                                  pageIndex = value.toInt() - 1;
                                  pageControllergit .animateToPage(
                                    pageIndex,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                  setState(() {});
                                },
                              ),
                              api: api,
                            ),
                          ),
                  ),
                ),
                body: ReaderPageWidget(
                  axis: axis,
                  reverse: reverse,
                  pageController: pageController2,
                  onPageChanged: (index) {
                    double value = index.toDouble() + 1;
                    if (!(value == 1 || value == imageUrls!.length + 2) && !isSliding) {
                      sliderValue = value;
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
                      showAppBar = false;
                    } else {
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                      showAppBar = true;
                    }
                    pageIndex = index;
                    setState(() {});
                  },
                  pages: pages,
                  onTapUp: (p0, p1, p2) => onTap(),
                ),
              ),
            );
          });
  }

  onTap() {
    if (showAppBar) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    showAppBar = !showAppBar;
    setState(() {});
  }
}
