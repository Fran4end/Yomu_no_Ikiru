import 'package:flutter/material.dart';
import 'package:manga_app/Pages/mangapage.dart';
import 'package:manga_app/costants.dart';
import 'package:manga_app/mangaBuilder.dart';

class Manga {
  final String? title;
  final String? author;
  final String? artist;
  final String? status;
  final List? genres;
  final List? chapters;
  final String? trama;
  final String? image;
  final String? link;
  final double? vote;
  final double? readings;

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
          builder: (context) =>
              MangaPage(manga: manga, mangaBuilder: mangaBuilder),
        )),
        child: Container(
          width: screen.width / 2,
          height: screen.height / 4.5,
          alignment: Alignment.bottomCenter,
          child: Stack(
            alignment: Alignment.bottomCenter,
            fit: StackFit.expand,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            children: [
              Card(
                elevation: 10,
                color: backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              Positioned(
                top: screen.height - (screen.height * 1.005),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Hero(
                        tag: manga.title.toString(),
                        child: manga.image == null
                            ? Image.asset('assets/blank.jpg')
                            : Image.network(
                                manga.image!,
                                height: screen.height / 6.1,
                                width: screen.width / 2.8,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: SizedBox(
                                      height: screen.height / 6.5,
                                      width: screen.width / 3,
                                    ),
                                  );
                                },
                              )),
                  ),
                ),
              ),
              Positioned(
                bottom: screen.height - (screen.height / 1.008),
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: screen.width / 2.5,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding / 2),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          manga.title.toString().length > 20
                              ? '${manga.title!.trim().characters.take(20)}...'
                              : manga.title.toString().trim(),
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.8),
          crossAxisSpacing: defaultPadding * 2,
        ),
        itemBuilder: ((context, index) {
          return MangaCard(
            manga: _listManga[index],
            mangaBuilder:
                mangasBuilder[_listManga[index].title.toString()] != null
                    ? mangasBuilder[_listManga[index].title.toString()]!
                    : MangaBuilder(),
          );
        }),
        itemCount: _listManga.length,
      ),
    );
  }
}
