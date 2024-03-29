import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yomu_no_ikiru/Api/adapter.dart';
import 'package:yomu_no_ikiru/view/widgets/Reader%20Page%20Widgets/reader_pages_widget.dart';

import '../../model/chapter.dart';
import '../../model/manga_builder.dart';

class Reader extends StatefulWidget {
  const Reader({
    required this.chapterIndex,
    required this.chapter,
    required this.pageIndex,
    required this.builder,
    required this.onScope,
    required this.axis,
    required this.reverse,
    required this.icon,
    required this.onPageChange,
    required this.api,
    this.lastPage = false,
    super.key,
  });
  final int chapterIndex, pageIndex;
  final Chapter chapter;
  final MangaBuilder builder;
  final Axis axis;
  final bool reverse;
  final Widget icon;
  final MangaApiAdapter api;
  final Function(MangaBuilder builder) onScope;
  final Function(int page, int chapterIndex) onPageChange;
  final bool lastPage;

  @override
  State<StatefulWidget> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  late final Function(MangaBuilder builder) onScope = widget.onScope;
  late final MangaBuilder builder = widget.builder;
  late bool reverse = widget.reverse;
  late Axis axis = widget.axis;
  late Widget icon = widget.icon;
  late int pageIndex = widget.pageIndex;
  bool showAppBar = false;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(widget.chapter.link!),
      );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    onScope(builder);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReaderPagesWidget(
      pageIndex: pageIndex,
      chapter: widget.chapter,
      builder: builder,
      axis: axis,
      icon: icon,
      onScope: onScope,
      reverse: reverse,
      chapters: builder.chapters,
      chapterIndex: widget.chapterIndex,
      showAppBar: showAppBar,
      controller: controller,
      onTap: () {
        if (showAppBar) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        } else {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
        }
        showAppBar = !showAppBar;
        setState(() {});
      },
      onPageChange: widget.onPageChange,
      api: widget.api,
      lastPage: widget.lastPage,
    );
  }
}

class LoadAnimation extends StatelessWidget {
  const LoadAnimation({super.key, required this.onTap});

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: const Center(child: CircularProgressIndicator()));
  }
}
