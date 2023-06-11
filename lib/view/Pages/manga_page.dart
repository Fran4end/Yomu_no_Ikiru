import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../constants.dart';
import '../../mangaworld.dart';
import '../../model/file_manager.dart';
import '../../model/manga.dart';
import '../../model/manga_builder.dart';
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

  @override
  void initState() {
    super.initState();
    if (mounted) {
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
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () async {
            mangaBuilder.alreadyLoaded = false;
            mangaBuilder.chapters.clear();
            await fetchData(reloadChapters: true);
          },
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  CustomSliverAppBar(
                    save: save,
                    manga: manga,
                    screen: screen,
                    tag: widget.tag,
                  ),
                  SliverToBoxAdapter(child: MangaPlot(manga: manga)),
                  buildChapters(manga),
                ],
              ),
              Positioned(
                bottom: 10,
                right: 20,
                child: buildBottomBar(manga),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomBar(Manga manga) {
    return SizedBox(
      height: 70,
      child: ElevatedButton.icon(
        onPressed: () async {
          if (manga.chapters.isNotEmpty && !isLoading) {
            mangaBuilder = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Reader(
                  index: (manga.chapters.length - manga.index) - 1,
                  chapters: manga.chapters,
                  chapter: manga.chapters[(manga.chapters.length - manga.index) - 1],
                  pageIndex: manga.pageIndex,
                  builder: mangaBuilder,
                ),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 10,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: const Icon(
          FontAwesomeIcons.play,
          size: 15,
        ),
        label: Center(
          child: Text('Resume', style: titleStyle()),
        ),
      ),
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
                      color: Colors.grey[900],
                      child: ListTile(
                        title: Text(
                          manga.chapters[index].title,
                          style: subtitleStyle(fontWeight: FontWeight.normal),
                        ),
                        subtitle: Text(
                          manga.chapters[index].date.toString(),
                          style: miniStyle(color: Colors.white.withOpacity(0.5)),
                        ),
                        onTap: () async {
                          int pIndex = 0;
                          if (manga.index == index) pIndex = manga.pageIndex;
                          mangaBuilder = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Reader(
                                index: index,
                                chapters: manga.chapters,
                                chapter: manga.chapters[index],
                                pageIndex: pIndex,
                                builder: mangaBuilder,
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
