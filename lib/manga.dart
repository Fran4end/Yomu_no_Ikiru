import 'package:flutter/material.dart';
import 'package:manga_app/Pages/manga_page.dart';
import 'package:manga_app/costants.dart';
import 'package:manga_app/manga_builder.dart';
import 'package:manga_app/manga_chaper.dart';

class Manga {
  final String? title;
  final String? author;
  final String? artist;
  final String? status;
  final String? trama;
  final String? image;
  final String? link;
  final double? vote;
  final double? readings;
  final List? genres;
  final Set<Chapter> chapters;

  Manga({required MangaBuilder builder})
      : title = builder.title,
        image = builder.image,
        link = builder.link,
        trama = builder.trama,
        status = builder.status,
        artist = builder.artist,
        author = builder.author,
        genres = builder.genres,
        vote = builder.vote,
        chapters = builder.chapters,
        readings = builder.readings;

  @override
  String toString() {
    return '$title -> ($author, $artist): $status ($vote, $readings) \n[$trama] $genres\n$image\n$link\n\n';
  }
}

class MangaCard extends StatelessWidget {
  const MangaCard({
    Key? key,
    required this.manga,
    required this.mangaBuilder,
  }) : super(key: key);

  final Manga manga;
  final MangaBuilder mangaBuilder;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MangaPage(manga: manga, mangaBuilder: mangaBuilder),
        )),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Container(
              width: orientation == Orientation.portrait ? screen.width / 2 : screen.width / 2,
              height: orientation == Orientation.portrait ? screen.height / 4.5 : screen.height / 2,
              alignment: Alignment.bottomCenter,
              child: Stack(
                alignment: Alignment.bottomCenter,
                fit: StackFit.expand,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                children: [
                  SizedBox(
                    height: (screen.height / 2) - 10,
                    child: Card(
                      elevation: 10,
                      margin: const EdgeInsets.all(defaultPadding),
                      color: backgroundColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  Positioned(
                    top: screen.height - (screen.height * 1.005),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Hero(
                            tag: manga.title.toString(),
                            child: Image.network(
                              manga.image!,
                              height: orientation == Orientation.portrait
                                  ? screen.height / 6.5
                                  : screen.height / 3,
                              width: orientation == Orientation.portrait
                                  ? screen.width / 3
                                  : screen.width / 6.1,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: SizedBox(
                                    height: orientation == Orientation.portrait
                                        ? screen.height / 6.1
                                        : screen.height / 3,
                                    width: orientation == Orientation.portrait
                                        ? screen.width / 3
                                        : screen.width / 6.1,
                                  ),
                                );
                              },
                            )),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: orientation == Orientation.portrait
                        ? (screen.height / 4) - 200
                        : (screen.height / 3) - 115,
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: orientation == Orientation.portrait
                          ? (screen.width / 2) - 60
                          : (screen.width / 4) - 60,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Text(
                              manga.title.toString().length > 20
                                  ? '${manga.title!.trim().characters.take(20)}...'
                                  : manga.title.toString().trim(),
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                              style: titleGreenStyle(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class MangaGrid extends StatelessWidget {
  const MangaGrid({
    Key? key,
    required List<Manga> listManga,
  })  : _listManga = listManga,
        super(key: key);

  final List<Manga> _listManga;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding / 2),
      child: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
              childAspectRatio: orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 2)
                  : (MediaQuery.of(context).size.width / 2) / MediaQuery.of(context).size.height,
              crossAxisSpacing: defaultPadding * 1.5,
            ),
            itemBuilder: ((context, index) {
              return MangaCard(
                manga: _listManga[index],
                mangaBuilder: mangasBuilder[_listManga[index].title.toString()] != null
                    ? mangasBuilder[_listManga[index].title.toString()]!
                    : MangaBuilder(),
              );
            }),
            itemCount: _listManga.length,
          );
        },
      ),
    );
  }
}
