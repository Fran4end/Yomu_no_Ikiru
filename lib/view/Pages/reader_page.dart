import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:manga_app/costants.dart';
import 'package:manga_app/model/chaper.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:manga_app/model/manga_builder.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:math';

import 'package:photo_view/photo_view_gallery.dart';

class Reader extends StatefulWidget {
  const Reader({
    required this.index,
    required this.chapters,
    required this.chapter,
    required this.pageIndex,
    required this.builder,
    super.key,
  });
  final int index, pageIndex;
  final List<Chapter> chapters;
  final Chapter chapter;
  final MangaBuilder builder;

  @override
  State<StatefulWidget> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  late final PageController pageController;
  late int pageIndex = widget.pageIndex;
  late MangaBuilder builder = widget.builder;
  List<String> imageUrls = [];
  Axis _axis = Axis.horizontal;
  Icon _icon = const Icon(Icons.keyboard_double_arrow_left);
  bool _showAppBar = false;
  bool _reverse = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.pageIndex);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    timer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => builder
          ..index = (widget.chapters.length - widget.index) - 1
          ..pageIndex = pageIndex);
    getImages().then((value) {
      setState(() {
        imageUrls = value;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, builder);
        return false;
      },
      child: Scaffold(
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
                          icon: _icon,
                          onPressed: () {
                            setState(() {
                              if (_axis == Axis.vertical && _reverse == false) {
                                _axis = Axis.horizontal;
                                _icon = const Icon(Icons.keyboard_double_arrow_right);
                                _reverse = false;
                              } else if (_reverse == false) {
                                _icon = const Icon(Icons.keyboard_double_arrow_left);
                                _reverse = true;
                              } else {
                                _axis = Axis.vertical;
                                _icon = const Icon(Icons.keyboard_double_arrow_down);
                                _reverse = false;
                              }
                            });
                          }),
                    )
                  ],
                ),
          body: imageUrls.isNotEmpty
              ? Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    PhotoViewGallery.builder(
                      pageController: pageController,
                      itemCount: imageUrls.length,
                      scrollDirection: _axis,
                      reverse: _reverse,
                      onPageChanged: (index) => setState(() {
                        pageIndex = index;
                      }),
                      builder: (context, index) {
                        final urlImage = imageUrls[index];
                        return PhotoViewGalleryPageOptions(
                          imageProvider: NetworkImage(urlImage),
                          minScale: PhotoViewComputedScale.contained,
                          onTapUp: (context, details, controllerValue) {
                            setState(() {
                              if (_showAppBar) {
                                SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
                              } else {
                                SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                              }
                              _showAppBar = !_showAppBar;
                            });
                          },
                        );
                      },
                    ),
                    Positioned(
                        right: -1,
                        bottom: 60,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${pageIndex + 1} / ${imageUrls.length}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        )),
                    !_showAppBar
                        ? const Center()
                        : Positioned(
                            bottom: 10,
                            child: SizedBox(
                              height: 60,
                              width: screen.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size((screen.width / 2) - 20, 40),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0)),
                                      backgroundColor: secondaryColor,
                                    ),
                                    onPressed: widget.index - 1 >= 0
                                        ? () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => Reader(
                                                          chapter:
                                                              widget.chapters[widget.index - 1],
                                                          chapters: widget.chapters,
                                                          pageIndex: 0,
                                                          index: widget.index - 1,
                                                          builder: widget.builder,
                                                        )));
                                          }
                                        : null,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Transform.rotate(
                                          angle: pi,
                                          child: const Icon(Icons.forward),
                                        ),
                                        const Text('Next Chapter'),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: widget.index + 1 < widget.chapters.length
                                        ? () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => Reader(
                                                          chapter:
                                                              widget.chapters[widget.index + 1],
                                                          chapters: widget.chapters,
                                                          index: widget.index + 1,
                                                          pageIndex: 0,
                                                          builder: widget.builder,
                                                        )));
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size((screen.width / 2) - 20, 40),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0)),
                                      backgroundColor: secondaryColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: const [
                                        Text('Previous Chapter'),
                                        Icon(Icons.forward),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                )
              : Center(
                  child: Container(),
                )),
    );
  }

  Future<List<String>> getImages() async {
    dom.Document document = await getChapter();
    List<String> imageUrls = [];

    try {
      var elements = document.querySelectorAll('#page > img');
      for (var element in elements) {
        imageUrls.add(element.attributes['src']!);
      }
    } catch (e, s) {
      if (kDebugMode) {
        print('$e: $s');
      }
    }

    return imageUrls;
  }

  Future<dom.Document> getChapter() async {
    http.Response response = await http.get(Uri.parse(widget.chapter.link!));
    dom.Document document = parse(response.body);

    return document;
  }
}
