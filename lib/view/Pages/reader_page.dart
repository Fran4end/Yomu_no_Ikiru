import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:yomu_no_ikiru/constants.dart';
import 'package:yomu_no_ikiru/controller/reader_page_controller.dart';
import 'package:yomu_no_ikiru/controller/utils.dart';

import '../../model/chapter.dart';
import '../../model/manga_builder.dart';

class Reader extends StatefulWidget {
  const Reader({
    required this.chapterIndex,
    required this.chapters,
    required this.chapter,
    required this.pageIndex,
    required this.builder,
    required this.onScope,
    super.key,
    required this.axis,
    required this.reverse,
    required this.icon,
  });
  final int chapterIndex, pageIndex;
  final List<Chapter> chapters;
  final Chapter chapter;
  final MangaBuilder builder;
  final Axis axis;
  final bool reverse;
  final Widget icon;
  final Function(MangaBuilder builder) onScope;

  @override
  State<StatefulWidget> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  late final PageController pageController;
  late final Function(MangaBuilder builder) onScope = widget.onScope;
  late final MangaBuilder builder = widget.builder;
  late bool reverse = widget.reverse;
  late Axis axis = widget.axis;
  late Widget icon = widget.icon;
  late int pageIndex = widget.pageIndex;

  bool _showAppBar = false;
  List<String> imageUrls = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: pageIndex);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    pageController.addListener(() {
      if (pageController.position.pixels == pageController.position.maxScrollExtent &&
          widget.chapterIndex - 1 >= 0) {
        ReaderPageController.nextChapter(
            context: context,
            builder: builder,
            chapters: widget.chapters,
            chapterIndex: widget.chapterIndex,
            axis: axis,
            icon: icon,
            reverse: reverse,
            onScope: onScope);
      } else if (pageController.position.pixels == pageController.position.minScrollExtent &&
          widget.chapterIndex + 1 < widget.chapters.length) {
        ReaderPageController.previousChapter(
            context: context,
            builder: builder,
            chapters: widget.chapters,
            chapterIndex: widget.chapterIndex,
            axis: axis,
            icon: icon,
            reverse: reverse,
            onScope: onScope);
      }
    });
    timer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => builder
          ..index = (widget.chapters.length - widget.chapterIndex) - 1
          ..pageIndex = pageIndex);
    ReaderPageController.getImages(chapter: widget.chapter).then((value) {
      imageUrls.add("https://luxpac.com/wp-content/uploads/2017/04/64_white-300x300.jpg");
      imageUrls.addAll(value);
      imageUrls.add("https://luxpac.com/wp-content/uploads/2017/04/64_white-300x300.jpg");
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        onScope(builder);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: !_showAppBar
            ? null
            : AppBar(
                title: Text(
                  widget.chapter.title.replaceAll(widget.builder.title, ''),
                  style: const TextStyle(fontSize: 14),
                ),
                actions: <Widget>[
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
                  )
                ],
              ),
        bottomNavigationBar: !_showAppBar
            ? null
            : Container(
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
                          ? widget.chapterIndex - 1 >= 0
                              ? () => ReaderPageController.nextChapter(
                                  context: context,
                                  builder: builder,
                                  chapters: widget.chapters,
                                  chapterIndex: widget.chapterIndex,
                                  axis: axis,
                                  icon: icon,
                                  reverse: reverse,
                                  onScope: onScope)
                              : null
                          : widget.chapterIndex + 1 < widget.chapters.length
                              ? () => ReaderPageController.previousChapter(
                                  context: context,
                                  builder: builder,
                                  chapters: widget.chapters,
                                  chapterIndex: widget.chapterIndex,
                                  axis: axis,
                                  icon: icon,
                                  reverse: reverse,
                                  onScope: onScope)
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
                          child: pageIndex < imageUrls.length - 1 && pageIndex > 0
                              ? Slider.adaptive(
                                  value: pageIndex + 1,
                                  divisions: imageUrls.length,
                                  label: (pageIndex).toString(),
                                  min: 2,
                                  max: imageUrls.length.toDouble() - 1,
                                  onChanged: (value) {
                                    setState(() {
                                      pageIndex = value.toInt() - 1;
                                      pageController.animateToPage(pageIndex,
                                          duration: const Duration(milliseconds: 1),
                                          curve: Curves.bounceInOut);
                                    });
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    IconButton.filled(
                      onPressed: !reverse
                          ? widget.chapterIndex - 1 >= 0
                              ? () => ReaderPageController.nextChapter(
                                  context: context,
                                  builder: builder,
                                  chapters: widget.chapters,
                                  chapterIndex: widget.chapterIndex,
                                  axis: axis,
                                  icon: icon,
                                  reverse: reverse,
                                  onScope: onScope)
                              : null
                          : widget.chapterIndex + 1 < widget.chapters.length
                              ? () => ReaderPageController.previousChapter(
                                  context: context,
                                  builder: builder,
                                  chapters: widget.chapters,
                                  chapterIndex: widget.chapterIndex,
                                  axis: axis,
                                  icon: icon,
                                  reverse: reverse,
                                  onScope: onScope)
                              : null,
                      tooltip: reverse ? "Previous chapter" : "Next chapter",
                      icon: const Icon(FontAwesomeIcons.forwardStep),
                      style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                            fixedSize: const MaterialStatePropertyAll(Size(20, 20)),
                          ),
                    ),
                  ],
                ),
              ),
        body: imageUrls.isNotEmpty
            ? PhotoViewGallery.builder(
                pageController: pageController,
                itemCount: imageUrls.length,
                scrollDirection: axis,
                reverse: reverse,
                onPageChanged: (index) {
                  if (index == imageUrls.length - 1 && widget.chapterIndex - 1 < 0) {
                    Utils.showSnackBar("No more chapter");
                    pageController.animateToPage(imageUrls.length - 2,
                        duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                  } else if (index == 0 && widget.chapterIndex + 1 >= widget.chapters.length) {
                    Utils.showSnackBar("It's the first chapter");
                    pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                  }
                  setState(() {
                    pageIndex = index;
                  });
                },
                builder: (context, index) {
                  final urlImage = imageUrls[index];
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(urlImage),
                    minScale: PhotoViewComputedScale.contained,
                    tightMode: true,
                    onTapUp: (context, details, controllerValue) {
                      setState(() {
                        if (_showAppBar) {
                          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
                        } else {
                          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                        }
                        _showAppBar = !_showAppBar;
                      });
                    },
                  );
                },
              )
            : const Center(),
      ),
    );
  }
}
