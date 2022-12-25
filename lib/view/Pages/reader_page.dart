import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:manga_app/chaper.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'dart:math';

import 'package:photo_view/photo_view_gallery.dart';

class Reader extends StatefulWidget {
  Reader({
    required this.index,
    required this.chapters,
    required this.chapter,
    required this.pageIndex,
    super.key,
  });
  final int index, pageIndex;
  final List<Chapter> chapters;
  final Chapter chapter;

  @override
  State<StatefulWidget> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  late final PageController pageController;
  late int index = widget.pageIndex;
  List<String> imageUrls = [];
  Axis _axis = Axis.horizontal;
  Icon _icon = const Icon(Icons.keyboard_double_arrow_left);
  bool _showAppBar = false;
  bool _reverse = true;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.pageIndex);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    getImages().then((value) {
      setState(() {
        imageUrls = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: !_showAppBar
            ? null
            : AppBar(
                title: Text(
                  widget.chapter.title,
                  style: const TextStyle(fontSize: 14),
                ),
                actions: <Widget>[
                  //TODO move tooltip on bottom
                  Tooltip(
                    message: "Previous Chapter",
                    child: IconButton(
                        icon: Transform.rotate(
                          angle: pi,
                          child: const Icon(Icons.forward),
                        ),
                        onPressed: widget.index + 1 < widget.chapters.length
                            ? () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Reader(
                                              chapter: widget.chapters[widget.index + 1],
                                              chapters: widget.chapters,
                                              index: widget.index + 1,
                                              pageIndex: 0,
                                            )));
                              }
                            : null),
                  ),
                  Tooltip(
                    message: "Next Chapter",
                    child: IconButton(
                        icon: const Icon(Icons.forward),
                        onPressed: widget.index - 1 >= 0
                            ? () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Reader(
                                              chapter: widget.chapters[widget.index - 1],
                                              chapters: widget.chapters,
                                              pageIndex: 0,
                                              index: widget.index - 1,
                                            )));
                              }
                            : null),
                  ),
                  Tooltip(
                    message: "Reader direction",
                    child: IconButton(
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
                children: [
                  PhotoViewGallery.builder(
                    pageController: pageController,
                    itemCount: imageUrls.length,
                    scrollDirection: _axis,
                    reverse: _reverse,
                    onPageChanged: (index) => setState(() {
                      this.index = index;
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
                      bottom: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${index + 1} / ${imageUrls.length}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      )),
                ],
              )
            : Center(
                child: Container(),
              ));
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
