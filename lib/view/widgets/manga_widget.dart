import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../constants.dart';
import '../../model/manga.dart';
import '../../model/manga_builder.dart';
import '../Pages/manga_page.dart';
import 'skeleton.dart';

class MangaCard extends StatelessWidget {
  const MangaCard({
    Key? key,
    required this.mangaBuilder,
    this.save = false,
    this.aspectRatio = 0.9,
    this.tag = '',
    this.maxLineText = 1,
  }) : super(key: key);

  final MangaBuilder mangaBuilder;
  final bool save;
  final String tag;
  final double maxLineText, aspectRatio;

  @override
  Widget build(BuildContext context) {
    Manga manga = mangaBuilder.build();
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MangaPage(
          mangaBuilder: mangaBuilder,
          save: save,
          tag: "${manga.title} $tag",
        ),
      )),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Card(
              elevation: 10,
              margin: const EdgeInsets.all(defaultPadding),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: defaultPadding * 1.5),
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Card(
                    elevation: 10,
                    clipBehavior: Clip.hardEdge,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Hero(
                      tag: "${manga.title} $tag",
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
                margin: const EdgeInsets.symmetric(horizontal: defaultPadding + 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AutoSizeText(
                  manga.title,
                  maxLines: maxLineText.toInt(),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  minFontSize: 16,
                  style: const TextStyle(color: Colors.greenAccent),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class MangaGrid extends StatelessWidget {
  const MangaGrid({
    Key? key,
    required this.listManga,
    this.axisCount = 2,
    this.save = false,
    this.tag = "grid",
  }) : super(key: key);

  final bool save;
  final List<MangaBuilder> listManga;
  final int axisCount;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: axisCount,
        childAspectRatio: .9,
      ),
      itemBuilder: ((context, index) {
        return MangaCard(
          mangaBuilder: listManga[index],
          save: save,
          tag: "$tag$index",
        );
      }),
      itemCount: listManga.length,
    );
  }
}
