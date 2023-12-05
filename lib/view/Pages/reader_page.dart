import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yomu_no_ikiru/constants.dart';

import '../../Api/adapter.dart';
import '../../controller/reader_page_controller.dart';
import '../../model/chapter.dart';
import '../../model/manga_builder.dart';
import '../widgets/Reader Page Widgets/animated_bar.dart';
import '../widgets/Reader Page Widgets/app_bar_reader_page.dart';
import '../widgets/Reader Page Widgets/bottom_navigation_bar_reader.dart';
import '../widgets/Reader Page Widgets/reader_page_widget.dart';

class Reader extends StatefulWidget {
  const Reader({
    required this.chapterIndex,
    required this.pageIndex,
    required this.builder,
    required this.onScope,
    required this.axis,
    required this.reverse,
    required this.icon,
    required this.onPageChange,
    required this.api,
    super.key,
  });
  final int chapterIndex, pageIndex;
  final MangaBuilder builder;
  final Axis axis;
  final bool reverse;
  final Widget icon;
  final MangaApiAdapter api;
  final Function(MangaBuilder builder) onScope;
  final Function(int page, int chapterIndex) onPageChange;

  @override
  State<StatefulWidget> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  late final Function(MangaBuilder builder) onScope = widget.onScope;
  late final MangaBuilder builder = widget.builder;
  late final WebViewController controller;
  late final api = widget.api;
  late Chapter chapter;
  late int chapterIndex = widget.chapterIndex;
  late bool reverse = widget.reverse;
  late Axis axis = widget.axis;
  late Widget icon = widget.icon;
  late int pageIndex = widget.pageIndex;
  late PageController pageController;

  List<PhotoViewGalleryPageOptions> pages = [];
  double sliderValue = 2;
  bool isSliding = false;
  bool isLoading = true;
  Map<Chapter, List<String>> imageUrls = {};
  bool showAppBar = false;

  @override
  void initState() {
    super.initState();
    final manga = builder.build();
    chapter = manga.chapters[widget.chapterIndex];
    pageController = PageController(initialPage: pageIndex);
    pageController.addListener(() {
      widget.onPageChange(
          pageController.page!.toInt(), (builder.chapters.length - chapterIndex) - 1);
    });
    controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
    _loadChapter(chapter.link!);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  _loadChapter(String link) {
    ReaderPageController.loadChapter(
      onFinish: (urls) {
        imageUrls[chapter] = urls;
        pages = ReaderPageController.buildPages(
          chapters: builder.chapters,
          chapterIndex: chapterIndex,
          imageUrls: imageUrls[chapter]!,
          onTapUp: (p0, p1, p2) => onTap(),
        );
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
    onScope(builder);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return imageUrls[chapter] == null
        ? const Center(child: CircularProgressIndicator())
        : Builder(builder: (context) {
            for (var img in imageUrls[chapter]!) {
              ReaderPageController.preloadImage(context, img);
            }
            return Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              appBar: AnimatedBar(
                begin: const Offset(0, -1),
                builder: () => !showAppBar
                    ? const SizedBox.shrink()
                    : ReaderPageAppBar(
                        chapter: chapter,
                        onPressed: () {
                          var (a, i, r) = ReaderPageController.changeDirection(
                              axis: axis, icon: icon, reverse: reverse);
                          setState(() {
                            axis = a;
                            icon = i;
                            reverse = r;
                          });
                        },
                        mangaTitle: builder.title,
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
                            reverse: reverse,
                            chapters: builder.chapters,
                            builder: builder,
                            chapterIndex: widget.chapterIndex,
                            axis: axis,
                            icon: icon,
                            onScope: onScope,
                            onPageChange: widget.onPageChange,
                            images: imageUrls[chapter]!,
                            pageIndex: pageIndex,
                            slider: Slider.adaptive(
                              inactiveColor: Theme.of(context).colorScheme.secondary,
                              value: sliderValue,
                              divisions: imageUrls[chapter]!.length + 2,
                              label: "${sliderValue.toInt() - 1} / ${imageUrls[chapter]!.length}",
                              min: 2,
                              max: (imageUrls[chapter]!.length.toDouble() + 1),
                              onChangeStart: (value) => setState(() {
                                isSliding = true;
                              }),
                              onChangeEnd: (value) => setState(() {
                                isSliding = false;
                              }),
                              onChanged: (value) {
                                if (!(value == 1 || value == imageUrls[chapter]!.length + 2)) {
                                  sliderValue = value;
                                }
                                pageIndex = value.toInt() - 1;
                                pageController.animateToPage(
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
                pageController: pageController,
                onPageChanged: (index) {
                  double value = index.toDouble() + 1;
                  if (!(value == 1 || value == imageUrls[chapter]!.length + 2) && !isSliding) {
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
