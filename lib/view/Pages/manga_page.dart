import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yomu_no_ikiru/constants.dart';
import '../../mangaworld.dart';
import '../../controller/file_manager.dart';
import '../../model/manga.dart';
import '../../model/manga_builder.dart';
import '../../controller/utils.dart';
import '../widgets/manga_page_appBar.dart';
import '../widgets/manga_page_detail.dart';
import 'reader_page.dart';

class MangaPage extends StatefulWidget {
  const MangaPage({
    required this.mangaBuilder,
    required this.save,
    required this.tag,
    super.key,
  });
  final MangaBuilder mangaBuilder;
  final bool save;
  final String tag;

  @override
  State<StatefulWidget> createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  late MangaBuilder mangaBuilder = widget.mangaBuilder;
  final User? user = FirebaseAuth.instance.currentUser;
  late bool save = widget.save;
  Timer? timer;
  bool isLoading = true;
  bool isToGoDown = true;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (mounted) {
      scrollController.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          isToGoDown = false;
          setState(() {});
        } else if (scrollController.position.pixels == scrollController.position.minScrollExtent) {
          isToGoDown = true;
          setState(() {});
        } else if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
          isToGoDown = true;
          setState(() {});
        } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
          isToGoDown = false;
          setState(() {});
        }
      });
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) {
          saveBookmark();
        },
      );
    }
    fetchData();
  }

  @override
  void dispose() {
    if (!isLoading) saveBookmark();
    timer?.cancel();
    super.dispose();
  }

  void saveBookmark() {
    if (save) {
      FileManager.writeFile(mangaBuilder);
    }
  }

  @override
  Widget build(BuildContext context) {
    final manga = mangaBuilder.build();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          mangaBuilder.alreadyLoaded = false;
          mangaBuilder.chapters.clear();
          await fetchData(reloadChapters: true);
        },
        child: Stack(
          children: [
            CustomScrollView(
              controller: scrollController,
              slivers: [
                CustomSliverAppBar(
                  save: save,
                  manga: manga,
                  tag: widget.tag,
                  rightButtonFunction: () {
                    if (user != null) {
                      if (save) {
                        FileManager.deleteFile(manga.title);
                      }
                      setState(() => save = !save);
                    } else {
                      Utils.showSnackBar('You need to login before save a manga');
                    }
                  },
                ),
                SliverToBoxAdapter(child: MangaPlot(manga: manga)),
                buildChapters(manga),
              ],
            ),
            Positioned(
              bottom: 25,
              width: MediaQuery.of(context).size.width,
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
                  child: buildBottomBar(manga)),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBottomBar(Manga manga) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 30,
          width: 30,
          child: Opacity(
            opacity: .7,
            child: IconButton.outlined(
              padding: const EdgeInsets.all(0.0),
              iconSize: 20,
              onPressed: () {
                if (isToGoDown) {
                  scrollController.animateTo(scrollController.position.maxScrollExtent,
                      duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);
                } else {
                  scrollController.animateTo(scrollController.position.minScrollExtent,
                      duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);
                }
                isToGoDown = !isToGoDown;
                setState(() {});
              },
              icon: isToGoDown
                  ? const Icon(FontAwesomeIcons.arrowDown)
                  : const Icon(FontAwesomeIcons.arrowUp),
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () async {
              if (manga.chapters.isNotEmpty && !isLoading) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Reader(
                      chapterIndex: (manga.chapters.length - manga.index) - 1,
                      chapters: manga.chapters,
                      chapter: manga.chapters[(manga.chapters.length - manga.index) - 1],
                      pageIndex: manga.pageIndex,
                      builder: mangaBuilder,
                      axis: Axis.horizontal,
                      icon: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: Icon(FontAwesomeIcons.mobileScreenButton),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 2),
                                child: const Icon(
                                  FontAwesomeIcons.arrowLeft,
                                  size: 7,
                                ),
                              )),
                        ],
                      ),
                      reverse: true,
                      onScope: (builder) => setState(() => mangaBuilder = builder),
                    ),
                  ),
                );
              }
            },
            icon: const Icon(FontAwesomeIcons.play, size: 20, color: Color(0xff0D0D0D)),
            label: const Center(
              child: Text('Resume', style: TextStyle(color: Color(0xff0D0D0D))),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildChapters(Manga manga) => SliverPadding(
        padding: const EdgeInsets.only(bottom: 90),
        sliver: SliverFixedExtentList(
          itemExtent: 80,
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return manga.chapters.isEmpty
                  ? null
                  : Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                          manga.chapters[index].title
                              .substring(manga.chapters[index].title.indexOf("Cap")),
                        ),
                        subtitle: Text(
                          manga.chapters[index].date.toString(),
                        ),
                        onTap: () async {
                          int pIndex = 1;
                          if (manga.index == manga.chapters.length - index - 1) {
                            pIndex = manga.pageIndex;
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Reader(
                                chapterIndex: index,
                                chapters: manga.chapters,
                                chapter: manga.chapters[index],
                                pageIndex: pIndex,
                                builder: mangaBuilder,
                                axis: Axis.horizontal,
                                icon: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Align(
                                      alignment: Alignment.center,
                                      child: Icon(FontAwesomeIcons.mobileScreenButton),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 2),
                                          child: const Icon(
                                            FontAwesomeIcons.arrowLeft,
                                            size: 7,
                                          ),
                                        )),
                                  ],
                                ),
                                reverse: true,
                                onScope: (builder) => setState(() => mangaBuilder = builder),
                              ),
                            ),
                          );
                        },
                      ),
                    );
            },
            childCount: manga.chapters.length,
          ),
        ),
      );

  Future fetchData({bool reloadChapters = false}) async {
    isLoading = true;
    MangaBuilder builder = await MangaWorld().getAllInfo(mangaBuilder, reloadChapters);
    mangaBuilder = builder;
    save = mangaBuilder.save;
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }
}
