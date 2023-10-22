import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../Pages/reader_page.dart';
import '../../../model/chapter.dart';
import '../../../model/manga_builder.dart';
import 'bottom_navigation_bar_reader.dart';
import '../../../controller/reader_page_controller.dart';
import '../../../controller/utils.dart';
import '../../../Api/Apis/mangaworld.dart';

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
  late Future document;
  late bool showAppBar = widget.showAppBar;
  late final onScope = widget.onScope;
  late final onPageChange = widget.onPageChange;
  List<String> imageUrls = [];
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
    document = MangaWorld().getPageDocument(chapter.link!);
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
        ));
  }

  @override
  Widget build(BuildContext context) {
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
              slider: pageIndex < imageUrls.length - 1 && pageIndex > 0
                  ? Slider.adaptive(
                      value: pageIndex + 1,
                      divisions: imageUrls.length,
                      label: (pageIndex).toString(),
                      min: 2,
                      max: imageUrls.length.toDouble() - 1,
                      onChanged: (value) {
                        pageIndex = value.toInt() - 1;
                        pageController.animateToPage(pageIndex,
                            duration: const Duration(milliseconds: 100), curve: Curves.bounceInOut);
                        setState(() {});
                      },
                    )
                  : null,
            ),
      body: FutureBuilder(
          future: document,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              imageUrls = [
                "https://luxpac.com/wp-content/uploads/2017/04/64_white-300x300.jpg",
                ...ReaderPageController.getImages(document: snapshot.data!),
                "https://luxpac.com/wp-content/uploads/2017/04/64_white-300x300.jpg"
              ];
              return FutureBuilder(
                  future: Future.wait(imageUrls
                      .map((url) => Future.value(CachedNetworkImage(
                            imageUrl: url,
                          )))
                      .toList()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return PhotoViewGallery.builder(
                        pageController: pageController,
                        itemCount: imageUrls.length,
                        scrollDirection: axis,
                        reverse: reverse,
                        onPageChanged: (index) {
                          if (index == imageUrls.length - 1 && widget.chapterIndex - 1 < 0) {
                            Utils.showSnackBar("No more chapter");
                            pageController.animateToPage(imageUrls.length - 2,
                                duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                          } else if (index == 0 &&
                              widget.chapterIndex + 1 >= widget.chapters.length) {
                            Utils.showSnackBar("It's the first chapter");
                            pageController.animateToPage(1,
                                duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                          }
                          setState(() {
                            pageIndex = index;
                          });
                        },
                        builder: (context, index) {
                          final image = snapshot.data![index];
                          return PhotoViewGalleryPageOptions.customChild(
                            //TODO: Mettere un widget speciale alla prima immagine e ultima
                            child: image,
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
                        },
                      );
                    }
                    return LoadAnimation(onTap: onTap);
                  });
            } else if (snapshot.hasError) {
              if (kDebugMode) {
                print("error on chapter pages");
              }
            }
            return LoadAnimation(onTap: onTap);
          }),
    );
  }
}
