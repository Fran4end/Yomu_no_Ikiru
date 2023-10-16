import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/dom.dart' as dom;
import '../../constants.dart';
import '../../model/chapter.dart';
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
  bool isOnLibrary = false;
  Timer? timer;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    FileManager.isOnLibrary(mangaBuilder.title).then((data) {
      if (data != null && mounted) {
        mangaBuilder = data;
        save = true;
        setState(() {});
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print("$error ");
      }
    });

    if (mounted) {
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) {
          saveBookmark();
        },
      );
    }
  }

  @override
  void dispose() {
    saveBookmark();
    scrollController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void saveBookmark() {
    if (save) {
      mangaBuilder.save = true;
      FileManager.writeFile(mangaBuilder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() {
          mangaBuilder.chapters.clear();
          setState(() {});
        }),
        child: FutureBuilder(
          future: MangaWorld().getDetailedPageDocument(mangaBuilder),
          builder: (context, snapshot) {
            dom.Document? document;
            if (snapshot.hasError) {
              Utils.showSnackBar(snapshot.error.toString());
              return const Center(
                child: Text("doc err"),
              );
            } else if (snapshot.hasData) {
              document = snapshot.data!;
              MangaWorld().getVote(document).then((vote) {
                if (mounted) {
                  if (vote == -1.0) {
                    Utils.showSnackBar("Can't take vote");
                  } else {
                    mangaBuilder.vote = vote;
                    setState(() {});
                  }
                }
              });
              mangaBuilder = MangaWorld().getAppBarInfo(mangaBuilder, document);
              mangaBuilder
                ..chapters = MangaWorld().getChapters(document)
                ..plot = MangaWorld().getPlot(document)
                ..readings = MangaWorld().getReadings(document);
            }
            final manga = mangaBuilder.build();
            return Stack(
              children: [
                CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    CustomSliverAppBar(
                      save: save,
                      mangaBuilder: mangaBuilder,
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
                    buildChapters(manga.chapters),
                  ],
                ),
                manga.chapters.isNotEmpty
                    ? Positioned(
                        bottom: 25,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
                            child: buildBottomBar(manga)),
                      )
                    : const Center(),
              ],
            );
          },
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
                  scrollController.animateTo(scrollController.position.maxScrollExtent,
                      duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);
                  setState(() {});
                },
                icon: const Icon(FontAwesomeIcons.arrowDown)),
          ),
        ),
        SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              if (manga.chapters.isNotEmpty) {
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

  Widget buildChapters(List<Chapter> chapters) => (chapters.isEmpty)
      ? const SliverToBoxAdapter()
      : SliverPadding(
          padding: const EdgeInsets.only(bottom: 90),
          sliver: SliverFixedExtentList(
            itemExtent: 80,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(
                      chapters[index].title.substring(chapters[index].title.indexOf("Cap")),
                    ),
                    subtitle: Text(
                      chapters[index].date.toString(),
                    ),
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Reader(
                            chapterIndex: index,
                            chapters: chapters,
                            chapter: chapters[index],
                            pageIndex: 1,
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
              childCount: chapters.length,
            ),
          ),
        );
}
