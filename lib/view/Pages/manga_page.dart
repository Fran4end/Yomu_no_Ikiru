import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yomu_no_ikiru/Api/adapter.dart';

import '../../constants.dart';
import '../../model/chapter.dart';
import '../../controller/file_manager.dart';
import '../../model/manga.dart';
import '../../model/manga_builder.dart';
import '../../controller/utils.dart';
import '../widgets/Manga Page Widgets/manga_page_appBar.dart';
import '../widgets/Manga Page Widgets/manga_page_detail.dart';
import 'reader_page.dart';

class MangaPage extends StatefulWidget {
  const MangaPage({
    required this.mangaBuilder,
    required this.save,
    required this.tag,
    required this.api,
    super.key,
  });
  final MangaBuilder mangaBuilder;
  final bool save;
  final String tag;
  final MangaApiAdapter api;

  @override
  State<StatefulWidget> createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  late MangaBuilder mangaBuilder = widget.mangaBuilder;
  final User? user = FirebaseAuth.instance.currentUser;
  late bool save = widget.save;
  bool isOnLibrary = false;
  bool isGetVote = false;
  late Future builder;
  late final api = widget.api;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    builder = api.getDetails(mangaBuilder, mangaBuilder.link);
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
  }

  @override
  void dispose() {
    saveBookmark();
    scrollController.dispose();
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
          builder = api.getDetails(mangaBuilder, mangaBuilder.link);
          setState(() {});
        }),
        child: FutureBuilder(
          future: builder,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              // print(mangaBuilder.link);
              if (kDebugMode) {
                print(snapshot.error);
              }
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              mangaBuilder = snapshot.data!;
              if (!isGetVote || mangaBuilder.vote == 0) {
                api.getVote(mangaBuilder).then((vote) {
                  if (mounted) {
                    if (vote == -1.0) {
                      Utils.showSnackBar("Can't take vote");
                    } else {
                      mangaBuilder.vote = vote;
                      isGetVote = true;
                      setState(() {});
                    }
                  }
                });
              }
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
                          } else {
                            saveBookmark();
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
                      onScope: (builder) {
                        setState(() => mangaBuilder = builder);
                        saveBookmark();
                      },
                      onPageChange: onPageChange,
                      api: api,
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
                      chapters[index].title,
                    ),
                    subtitle: Text(
                      chapters[index].date.toString(),
                    ),
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Reader(
                            chapterIndex: index,
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
                                        size: 10,
                                      ),
                                    )),
                              ],
                            ),
                            reverse: true,
                            onScope: (builder) {
                              mangaBuilder = builder;
                              saveBookmark();
                            },
                            onPageChange: onPageChange,
                            api: api,
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

  onPageChange(int page, int chapterIndex) {
    mangaBuilder
      ..pageIndex = page
      ..index = chapterIndex;
    saveBookmark();
  }
}
