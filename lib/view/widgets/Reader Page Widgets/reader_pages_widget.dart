import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
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
  final Function() onTap;
  final Function(int page, int chapterIndex) onPageChange;

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
  late Future<List<String>> imageUrls;
  late final PageController pageController;
  late final onTap = widget.onTap;

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: pageIndex);
    imageUrls = api.getImageUrls(chapter.link!);
    pageController.addListener(() => ReaderPageController.pageControllerListener(
          imageUrls: imageUrls,
          pageController: pageController,
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: imageUrls,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
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
                        slider: pageIndex < images.length && pageIndex > 0
                            ? Slider.adaptive(
                                value: pageIndex + 1,
                                divisions: images.length,
                                label: (pageIndex).toString(),
                                min: 2,
                                max: images.length.toDouble(),
                                onChanged: (value) {
                                  pageIndex = value.toInt() - 1;
                                  pageController.animateToPage(pageIndex,
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
                    if (index == images.length && widget.chapterIndex - 1 < 0) {
                      Utils.showSnackBar("No more chapter");
                      pageController.animateToPage(images.length - 1,
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
                    if (index == 0 || index == images.length) {
                      index--;
                      return PhotoViewGalleryPageOptions.customChild(
                        child: Center(
                          child: Text("Chapter ${widget.chapter.title} is finished"),
                        ),
                      );
                    } else {
                      final image = CachedNetworkImageProvider(images[index]);
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
