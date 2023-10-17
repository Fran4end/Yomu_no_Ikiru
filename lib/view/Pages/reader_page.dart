import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yomu_no_ikiru/view/widgets/reader_pages_widget.dart';

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
  late final Function(MangaBuilder builder) onScope = widget.onScope;
  late final MangaBuilder builder = widget.builder;
  late bool reverse = widget.reverse;
  late Axis axis = widget.axis;
  late Widget icon = widget.icon;
  late int pageIndex = widget.pageIndex;
  bool showAppBar = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    timer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => builder
          ..index = (widget.chapters.length - widget.chapterIndex) - 1
          ..pageIndex = pageIndex);
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
      child: ReaderPagesWidget(
        pageIndex: pageIndex,
        chapter: widget.chapter,
        builder: builder,
        axis: axis,
        icon: icon,
        onScope: onScope,
        reverse: reverse,
        chapters: widget.chapters,
        chapterIndex: widget.chapterIndex,
        showAppBar: showAppBar,
        onTap: () {
          if (showAppBar) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
          } else {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                overlays: [SystemUiOverlay.top]);
          }
          showAppBar = !showAppBar;
          setState(() {});
        },
      ),
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