import 'package:flutter/material.dart';
import 'package:manga_app/costants.dart';
import 'package:url_launcher/url_launcher.dart';

class Manga {
  final String title;
  final String author;
  final String artist;
  final String status;
  final List genres;
  final String trama;
  final String image;
  final String link;

  Manga({
    this.artist = '',
    this.author = '',
    required this.image,
    this.genres = const [],
    required this.status,
    required this.title,
    required this.link,
    this.trama = '',
  });
}

class MangaCard extends StatelessWidget {
  const MangaCard({
    Key? key,
    required this.title,
    required this.image,
    required this.link,
  }) : super(key: key);

  final String image, title, link;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Center(
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(link)),
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
                //color: const Color.fromRGBO(168, 255, 219, 100),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              Positioned(
                bottom: screen.height / 15.5,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      image,
                      height: screen.height / 6.5,
                      width: screen.width / 3,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: SizedBox(
                            height: screen.height / 6.5,
                            width: screen.width / 3,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: screen.height / 100,
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: screen.width / 2.5,
                  child: Center(
                    child: Text(
                      title,
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
    required this.height,
  })  : _listManga = listManga,
        super(key: key);

  final List<Manga> _listManga;
  final double height;

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
        itemBuilder: ((context, index) => MangaCard(
              image: _listManga[index].image,
              title: _listManga[index].title.trim().length > 35
                  ? '${_listManga[index].title.trim().characters.take(35)}...'
                  : _listManga[index].title.trim(),
              link: _listManga[index].link,
            )),
        itemCount: _listManga.length,
      ),
    );
  }
}
