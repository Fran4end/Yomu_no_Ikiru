/*
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yomu_no_ikiru/model/manga.dart';

import '../../../Api/adapter.dart';
import '../../../controller/reader_page_controller.dart';
import '../../../model/chapter.dart';

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
  });
  final int chapterIndex, pageIndex;
  final Manga manga;
  final Axis axis;
  final bool reverse, showAppBar;
  final Widget icon;
  final MangaApiAdapter api;
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
  late bool showAppBar = widget.showAppBar;

  List<String>? imageUrls;
  double sliderValue = 2;
  bool isSliding = false;

  @override
  void initState() {
    super.initState();
    
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
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Builder(
            builder: (context) {},
          );
  }
}
*/