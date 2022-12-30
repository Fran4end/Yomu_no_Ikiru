import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../costants.dart';
import '../../model/manga.dart';
import '../../model/manga_builder.dart';
import '../Pages/manga_page.dart';

class MangaCard extends StatelessWidget {
  const MangaCard({
    Key? key,
    required this.manga,
    required this.mangaBuilder,
    this.save = false,
  }) : super(key: key);

  final Manga manga;
  final MangaBuilder mangaBuilder;
  final bool save;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MangaPage(
            mangaBuilder: mangaBuilder,
            save: save,
          ),
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
                            child: SizedBox(
                              height: orientation == Orientation.portrait
                                  ? screen.height / 6.5
                                  : screen.height / 3,
                              width: orientation == Orientation.portrait
                                  ? screen.width / 3
                                  : screen.width / 6.1,
                              child: Image.network(
                                manga.image!,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  bool timeout = false;
                                  do {
                                    try {
                                      if (loadingProgress == null) {
                                        timeout = false;
                                        return child;
                                      }
                                      return Center(
                                        child: SizedBox(
                                          height: orientation == Orientation.portrait
                                              ? screen.height / 6.1
                                              : screen.height / 3,
                                          width: orientation == Orientation.portrait
                                              ? screen.width / 3
                                              : screen.width / 6.1,
                                          child: const Center(child: CircularProgressIndicator()),
                                        ),
                                      );
                                    } catch (e) {
                                      timeout = true;
                                      if (kDebugMode) {
                                        print('manga 120: $e');
                                      }
                                    }
                                  } while (timeout);
                                },
                              ),
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
    required,
    this.save = false,
  })  : _listManga = listManga,
        super(key: key);

  final List<Manga> _listManga;
  final bool save;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 200,
            crossAxisCount: 2,
            childAspectRatio: orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 2)
                : (MediaQuery.of(context).size.width / 2) / MediaQuery.of(context).size.height,
            crossAxisSpacing: defaultPadding * 1.5,
            mainAxisSpacing: orientation == Orientation.portrait ? defaultPadding / 2 : 2,
          ),
          itemBuilder: ((context, index) {
            return MangaCard(
              manga: _listManga[index],
              mangaBuilder: mangasBuilder[_listManga[index].title.toString()] != null
                  ? mangasBuilder[_listManga[index].title.toString()]!
                  : MangaBuilder(),
              save: save,
            );
          }),
          itemCount: _listManga.length,
        );
      },
    );
  }
}
