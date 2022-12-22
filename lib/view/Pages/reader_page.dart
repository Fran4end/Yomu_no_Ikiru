import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:manga_app/chaper.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'dart:math';

class Reader extends StatefulWidget {
  const Reader({
    required this.index,
    required this.chapters,
    required this.chapter,
    super.key,
  });
  final int index;
  final List<Chapter> chapters;
  final Chapter chapter;

  @override
  State<StatefulWidget> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  List<String> imageUrls = [];
  Axis _axis = Axis.vertical;
  Icon _icon = const Icon(Icons.stay_current_portrait);
  bool _showAppBar = false;
  bool _reverse = false;

  @override
  void initState() {
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
                                              index: widget.index - 1,
                                            )));
                              }
                            : null),
                  ),
                  IconButton(
                      icon: _icon,
                      onPressed: () {
                        setState(() {
                          if (_axis == Axis.vertical) {
                            _axis = Axis.horizontal;
                            _icon = const Icon(Icons.stay_current_landscape);
                          } else {
                            _axis = Axis.vertical;
                            _icon = const Icon(Icons.stay_current_portrait);
                          }
                          _reverse = !_reverse;
                        });
                      })
                ],
              ),
        body: imageUrls.isNotEmpty
            ? CustomScrollView(
                scrollDirection: _axis,
                reverse: _reverse,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                                child: PhotoView(
                              onTapDown: (context, details, controllerValue) {
                                setState(() {
                                  if (_showAppBar) {
                                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
                                  } else {
                                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                                  }
                                  _showAppBar = !_showAppBar;
                                });
                              },
                              imageProvider: NetworkImage(imageUrls[index]),
                              backgroundDecoration: const BoxDecoration(color: Colors.black),
                            )),
                            Positioned(
                                right: -1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${index + 1} / ${imageUrls.length}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )),
                          ],
                        ),
                      );
                    }, childCount: imageUrls.length),
                  )
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
