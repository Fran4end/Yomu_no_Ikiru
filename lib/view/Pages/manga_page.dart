import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/constants.dart';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/model/manga_builder.dart';
import 'package:manga_app/mangaworld.dart';
import 'package:manga_app/view/Pages/reader_page.dart';
import '../../model/file_manager.dart';
import '../../model/utils.dart';
import '../widgets/manga_page_widget.dart';

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
  Map fileContent = {};
  final User? user = FirebaseAuth.instance.currentUser;
  late bool save = widget.save;
  Timer? timer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    MangaWorld().getAllInfo(mangaBuilder).then((value) {
      mangaBuilder = value;
      if (mounted) {
        timer = Timer.periodic(
          const Duration(seconds: 3),
          (_) {
            saveBookmark();
          },
        );
        setState(() {
          isLoading = false;
          if (mangaBuilder.save != save) {
            save = mangaBuilder.save;
          }
        });
      }
    });
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
      body: OrientationBuilder(
        builder: (context, orientation) => Stack(
          fit: StackFit.expand,
          children: [
            CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  delegate: CustomSliverAppBarDelegate(
                    manga: manga,
                    tag: widget.tag,
                    mangaImage: manga.image,
                    screen: screen,
                    expandedHeight: 450,
                    save: save,
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
                  pinned: true,
                ),
                buildChapters(manga),
              ],
            ),
            Positioned(
              bottom: 30,
              child: buildBottomBar(screen, manga),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomBar(Size screen, Manga manga) {
    return SizedBox(
      width: screen.width - 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
            child: Container(
              height: 30,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                manga.status.toString(),
                style: titleGreenStyle(),
              ),
            ),
          ),
          ElevatedButton(
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
              fixedSize: Size((screen.width / 2) - 50, 45),
              elevation: 10,
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            ),
            child: Center(
              child: Text('Resume', style: titleStyle()),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChapters(Manga manga) => SliverPadding(
        padding: const EdgeInsets.only(bottom: 90),
        sliver: SliverList(
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
                          style: subtitleStyle(),
                        ),
                        subtitle: Text(
                          manga.chapters[index].date.toString(),
                          style: miniStyle(),
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
}
