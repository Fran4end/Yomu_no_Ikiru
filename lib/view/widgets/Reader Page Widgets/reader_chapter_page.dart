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
    required this.onLastPage,
    required this.onFirstPage,
    required this.pageIndex,
    required this.pageController1,
  });
  final int chapterIndex, pageIndex;
  final Manga manga;
  final Axis axis;
  final bool reverse, showAppBar;
  final Widget icon;
  final MangaApiAdapter api;
  final PageController pageController1;
  final Function(Manga manga) onScope;
  final Function(int page, int chapterIndex) onPageChange;
  final Function(int chapterIndex) onLastPage;
  final Function(int chapterIndex) onFirstPage;

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
  late PageController pageController2;
  late PageController pageController1 = widget.pageController1;
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
    pageController2 = PageController(initialPage: pageIndex);
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
            pageController2.addListener(() => ReaderPageController.pageControllerListener(
                  imageUrls: imageUrls!,
                  pageController: pageController2,
                  manga: manga,
                  chapterIndex: chapterIndex,
                  onPageChange: widget.onPageChange,
                  onFirstPage: widget.onFirstPage,
                  onLastPage: widget.onLastPage,
                ));
            for (var img in imageUrls!) {
              ReaderPageController.preloadImage(context, img);
            }
            return NotificationListener(
              onNotification: (notification) {
                if (notification is OverscrollNotification && notification.overscroll < 0) {
                  leftOverScroll += notification.overscroll;
                  pageController1.position
                      .correctPixels(pageController1.position.pixels + notification.overscroll);
                  pageController1.position.notifyListeners();
                }

                if (leftOverScroll < 0) {
                  if (notification is ScrollUpdateNotification) {
                    final newOverScroll = min(notification.metrics.pixels + leftOverScroll, 0.0);
                    final diff = newOverScroll - leftOverScroll;
                    pageController1.position.correctPixels(pageController1.position.pixels + diff);
                    pageController1.position.notifyListeners();
                    leftOverScroll = newOverScroll;
                    pageController2.position.correctPixels(0);
                    pageController2.position.notifyListeners();
                  }
                }

                if (notification is UserScrollNotification &&
                    notification.direction == ScrollDirection.idle &&
                    leftOverScroll != 0) {
                  pageController1.previousPage(
                      curve: Curves.ease, duration: const Duration(milliseconds: 400));
                  leftOverScroll = 0;
                }

                if (notification is OverscrollNotification && notification.overscroll > 0) {
                  rightOverScroll += notification.overscroll;
                  pageController1.position
                      .correctPixels(pageController1.position.pixels + notification.overscroll);
                  pageController1.position.notifyListeners();
                }

                if (rightOverScroll > 0) {
                  if (notification is ScrollUpdateNotification) {
                    final maxScrollExtent = notification.metrics.maxScrollExtent;
                    final newOverScroll =
                        max(notification.metrics.pixels + rightOverScroll - maxScrollExtent, 0.0);
                    final diff = newOverScroll - rightOverScroll;
                    pageController1.position.correctPixels(pageController1.position.pixels + diff);
                    pageController1.position.notifyListeners();
                    rightOverScroll = newOverScroll;
                    pageController2.position.correctPixels(maxScrollExtent);
                    pageController2.position.notifyListeners();
                  }
                }

                if (notification is UserScrollNotification &&
                    notification.direction == ScrollDirection.idle &&
                    rightOverScroll != 0) {
                  pageController1.nextPage(
                      curve: Curves.ease, duration: const Duration(milliseconds: 400));
                  rightOverScroll = 0;
                }

                return false;
              },
              child: Scaffold(
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
                              pageController1: pageController1,
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
                              onLastPage: widget.onLastPage,
                              onFirstPage: widget.onFirstPage,
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
                                  pageController2.animateToPage(
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
                  imageUrls: imageUrls!,
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
