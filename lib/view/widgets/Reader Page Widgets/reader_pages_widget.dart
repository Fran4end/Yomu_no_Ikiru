import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yomu_no_ikiru/Api/Adapter/mangakatana_adapter.dart';
import 'package:yomu_no_ikiru/Api/adapter.dart';

import '../../Pages/reader_page.dart';
import '../../../model/chapter.dart';
import '../../../model/manga_builder.dart';
import 'bottom_navigation_bar_reader.dart';
import '../../../controller/reader_page_controller.dart';
import '../../../controller/utils.dart';

class ReaderPagesWidget extends StatefulWidget {
  final int pageIndex;
  final Chapter chapter;
  final MangaBuilder builder;
  final Axis axis;
  final Widget icon;
  final bool reverse;
  final List<Chapter> chapters;
  final int chapterIndex;
  final Function(MangaBuilder) onScope;
  final bool showAppBar;
  final MangaApiAdapter api;
  final WebViewController controller;
  final Function() onTap;
  final Function(int page, int chapterIndex) onPageChange;
  final bool lastPage;

  const ReaderPagesWidget({
    super.key,
    required this.pageIndex,
    required this.chapter,
    required this.builder,
    required this.axis,
    required this.icon,
    required this.onScope,
    required this.reverse,
    required this.chapters,
    required this.chapterIndex,
    required this.showAppBar,
    required this.onTap,
    required this.onPageChange,
    required this.api,
    required this.controller,
    required this.lastPage,
  });

  @override
  State<StatefulWidget> createState() => _ReaderPagesWidgetState();
}

class _ReaderPagesWidgetState extends State<ReaderPagesWidget> {
  late int pageIndex = widget.pageIndex;
  late final chapter = widget.chapter;
  late final MangaBuilder builder = widget.builder;
  late bool reverse = widget.reverse;
  late Axis axis = widget.axis;
  late Widget icon = widget.icon;
  late MangaApiAdapter api = widget.api;
  late bool showAppBar = widget.showAppBar;
  late final onScope = widget.onScope;
  late final onPageChange = widget.onPageChange;
  Future<List<String>>? imageUrls;
  PageController? pageController;
  late final onTap = widget.onTap;
  late final lastPage = widget.lastPage;

  @override
  void dispose() {
    super.dispose();
    pageController?.dispose();
  }

  _setController() {
    imageUrls!.then((images) {
      if (mounted) {
        if (lastPage) {
          pageIndex = images.length;
        }
        pageController = PageController(initialPage: pageIndex);
        pageController?.addListener(() => ReaderPageController.pageControllerListener(
              imageUrls: imageUrls!,
              pageController: pageController!,
              context: context,
              builder: builder,
              chapters: widget.chapters,
              chapterIndex: widget.chapterIndex,
              axis: axis,
              icon: icon,
              reverse: reverse,
              onScope: onScope,
              onPageChange: onPageChange,
              api: api,
            ));
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    if (api.runtimeType == MangaKatanaAdapter) {
      widget.controller.setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            var document = await widget.controller
                .runJavaScriptReturningResult('document.documentElement.innerHTML');
            var dom = parse(json.decode(document.toString()));
            imageUrls = api.getImageUrls(dom);
            _setController();
            setState(() {});
          },
        ),
      );
    } else {
      imageUrls = api.getImageUrls(chapter.link!);
      _setController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return imageUrls == null
        ? const Center(child: CircularProgressIndicator())
        : FutureBuilder(
            future: imageUrls,
            builder: (context, snapshot) {
              if (snapshot.data != null &&
                  snapshot.data!.isEmpty &&
                  api.runtimeType != MangaKatanaAdapter) {
                return const Center(child: Text("No chapter pages found"));
              } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                final List<String> images = snapshot.data!;
                for (var img in images) {
                  ReaderPageController.preload(context, img);
                }
                return Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: !showAppBar
                        ? null
                        : AppBar(
                            title: Text(
                              widget.chapter.title.replaceAll(widget.builder.title, ''),
                              style: const TextStyle(fontSize: 14),
                            ),
                            actions: [
                              Tooltip(
                                message: "Reader direction",
                                child: ElevatedButton.icon(
                                    label: const Text('Reader direction'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent, elevation: 0),
                                    icon: icon,
                                    onPressed: () {
                                      var (a, i, r) = ReaderPageController.changeDirection(
                                          axis: axis, icon: icon, reverse: reverse);
                                      setState(() {
                                        axis = a;
                                        icon = i;
                                        reverse = r;
                                      });
                                    }),
                              ),
                            ],
                          ),
                    bottomNavigationBar: !showAppBar
                        ? null
                        : ReaderBottomNavigationBar(
                            reverse: reverse,
                            chapters: widget.chapters,
                            builder: builder,
                            chapterIndex: widget.chapterIndex,
                            axis: axis,
                            icon: icon,
                            onScope: onScope,
                            onPageChange: onPageChange,
                            images: images,
                            pageIndex: pageIndex,
                            slider: pageIndex < images.length + 1 && pageIndex > 0
                                ? Slider(
                                    value: pageIndex + 1,
                                    divisions: images.length + 1,
                                    label: (pageIndex).toString(),
                                    min: 2,
                                    max: (images.length.toDouble() + 1),
                                    onChanged: (value) {
                                      pageIndex = value.toInt() - 1;
                                      pageController?.animateToPage(pageIndex,
                                          duration: const Duration(milliseconds: 100),
                                          curve: Curves.bounceInOut);
                                      setState(() {});
                                    },
                                  )
                                : null,
                            api: api,
                          ),
                    body: PhotoViewGallery.builder(
                      pageController: pageController,
                      itemCount: images.length + 2,
                      scrollDirection: axis,
                      reverse: reverse,
                      onPageChanged: (index) {
                        if (index == images.length + 1 && widget.chapterIndex - 1 < 0) {
                          Utils.showSnackBar("No more chapter");
                          pageController?.animateToPage(images.length - 1,
                              duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                        } else if (index == 0 &&
                            widget.chapterIndex + 1 >= widget.chapters.length) {
                          Utils.showSnackBar("It's the first chapter");
                          pageController?.animateToPage(1,
                              duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                        }
                        setState(() {
                          pageIndex = index;
                        });
                      },
                      builder: (context, index) {
                        if (index == 0) {
                          return PhotoViewGalleryPageOptions.customChild(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Chapter ${chapter.title} is finished"),
                                  widget.chapterIndex + 1 < widget.chapters.length
                                      ? Text(
                                          "Going to chapter ${widget.chapters[widget.chapterIndex + 1].title}")
                                      : const Center(),
                                ],
                              ),
                            ),
                          );
                        } else if (index == images.length + 1) {
                          return PhotoViewGalleryPageOptions.customChild(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Chapter ${chapter.title} is finished"),
                                  widget.chapterIndex - 1 >= 0
                                      ? Text(
                                          "Going to chapter ${widget.chapters[widget.chapterIndex - 1].title}")
                                      : const Center(),
                                ],
                              ),
                            ),
                          );
                        } else {
                          final image = CachedNetworkImageProvider(images[index - 1]);
                          return PhotoViewGalleryPageOptions(
                            imageProvider: image,
                            minScale: PhotoViewComputedScale.contained,
                            tightMode: true,
                            onTapUp: (context, details, controllerValue) {
                              setState(() {
                                if (showAppBar) {
                                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
                                } else {
                                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                                      overlays: [SystemUiOverlay.top]);
                                }
                                showAppBar = !showAppBar;
                              });
                            },
                          );
                        }
                      },
                    ));
              }
              return LoadAnimation(onTap: onTap);
            });
  }
}
