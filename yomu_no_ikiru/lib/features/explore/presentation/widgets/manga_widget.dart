import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yomu_no_ikiru/constants.dart';
import 'package:yomu_no_ikiru/core/common/widgets/skeleton.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';
import 'package:yomu_no_ikiru/features/details/presentation/page/manga_detail_page.dart';

class MangaCard extends StatelessWidget {
  const MangaCard({
    super.key,
    required this.manga,
    this.save = false,
    this.aspectRatio = 0.9,
    this.maxLineText = 1,
    this.tag = "",
  });

  final Manga manga;
  final bool save;
  final double maxLineText, aspectRatio;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MangaDetailPage.route(
            tag: tag,
            manga: manga,
          ),
        );
      },
      child: Stack(
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
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Hero(
                            tag: "${manga.id} $tag",
                            child: CachedNetworkImage(
                              imageUrl: manga.coverUrl,
                              fit: BoxFit.cover,
                              // progressIndicatorBuilder: (context, url, downloadProgress) =>
                              //     const Center(child: Skeleton(color: Colors.white)),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Hero(
                          tag: "${manga.id}_status $tag",
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary,
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(defaultPadding / 3),
                              child: Text(manga.status.name),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: defaultPadding + 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  manga.title,
                  maxLines: maxLineText.toInt(),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MangaGrid extends StatelessWidget {
  const MangaGrid({
    super.key,
    this.save = false,
    this.tag = "grid",
    required this.mangaList,
    required this.hasReachedMax,
    required this.scrollController,
  });

  final List<Manga> mangaList;
  final bool save;
  final bool hasReachedMax;
  final String tag;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .9,
        ),
        scrollDirection: Axis.vertical,
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: hasReachedMax ? mangaList.length : mangaList.length + 1,
        itemBuilder: (context, index) {
          return index >= mangaList.length
              ? const SkeletonCard(aspectRatio: .9)
              : MangaCard(
                  manga: mangaList[index],
                  save: save,
                  tag: '${mangaList[index].id}_$tag',
                );
        });
  }
}
