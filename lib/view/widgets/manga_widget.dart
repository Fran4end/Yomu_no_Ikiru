import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:manga_app/view/widgets/skeleton.dart';

import '../../constants.dart';
import '../../model/manga.dart';
import '../../model/manga_builder.dart';
import '../Pages/manga_page.dart';

class MangaCard extends StatelessWidget {
  const MangaCard({
    Key? key,
    required this.mangaBuilder,
    this.iHeight = 180,
    this.iWidth = 140,
    this.save = false,
    this.tag = '',
    this.maxLineText = 1,
  }) : super(key: key);

  final MangaBuilder mangaBuilder;
  final bool save;
  final String tag;
  final double maxLineText, iHeight, iWidth;

  @override
  Widget build(BuildContext context) {
    Manga manga = mangaBuilder.build();
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MangaPage(
          mangaBuilder: mangaBuilder,
          save: save,
        ),
      )),
      child: SizedBox(
        height: iHeight * 1.5,
        width: iWidth * 1.5,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: iHeight * 1.5,
              width: iWidth * 1.5,
              child: Card(
                elevation: 10,
                margin: const EdgeInsets.all(defaultPadding),
                color: backgroundColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Positioned(
              top: -5,
              child: Column(
                children: [
                  Card(
                    elevation: 10,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Hero(
                        tag: manga.title.toString() + tag,
                        child: SizedBox(
                          height: iHeight,
                          width: iWidth,
                          child: CachedNetworkImage(
                            imageUrl: manga.image,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                const Center(child: Skeleton(color: Colors.white)),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: const EdgeInsets.only(top: defaultPadding / 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: iWidth,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                          child: AutoSizeText(
                            manga.title,
                            maxLines: maxLineText.toInt(),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: titleGreenStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MangaGrid extends StatelessWidget {
  const MangaGrid({
    Key? key,
    required this.listManga,
    required,
    this.save = false,
  }) : super(key: key);

  final bool save;
  final List<MangaBuilder> listManga;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: defaultPadding,
      ),
      itemBuilder: ((context, index) {
        return Center(
          child: MangaCard(
            mangaBuilder: listManga[index],
            save: save,
            iHeight: 160,
            iWidth: 140,
          ),
        );
      }),
      itemCount: listManga.length,
    );
  }
}
