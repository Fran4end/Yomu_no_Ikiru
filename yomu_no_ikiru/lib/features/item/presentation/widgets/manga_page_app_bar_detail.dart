import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:yomu_no_ikiru/core/common/widgets/skeleton.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';
import 'package:yomu_no_ikiru/features/item/presentation/widgets/manga_page_genres_wrap.dart';

import '../../../../core/utils/constants.dart';

/// Widget that displays the plot of the manga.
/// 
/// This widget is an [ExpandablePanel] that displays the plot of the manga.
/// TODO: Add a possibility to pop up more information from exterlal site of tracking (such as MyAnimeList, AniList, etc.).
class MangaPlot extends StatelessWidget {
  final double expandedHeight;
  final Manga manga;

  const MangaPlot({
    super.key,
    required this.manga,
    this.expandedHeight = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      child: ExpandableNotifier(
        child: ExpandablePanel(
          header: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                color: Colors.orange,
                size: 22.0,
              ),
              const SizedBox(width: defaultPadding / 2),
              Text(
                manga.info.rank.toString(),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              ),
              const SizedBox(width: defaultPadding / 2),
              Text(
                '(${manga.info.users})',
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
          collapsed: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                manga.plot,
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.fade,
              ),
              const Positioned(
                bottom: -8,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 25,
                ),
              ),
            ],
          ),
          expanded: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: defaultPadding),
                child: Text(manga.plot),
              ),
              const Positioned(
                bottom: -10,
                child: Icon(
                  Icons.keyboard_arrow_up,
                  size: 25,
                ),
              ),
            ],
          ),
          theme: const ExpandableThemeData(
            hasIcon: false,
            useInkWell: false,
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            bodyAlignment: ExpandablePanelBodyAlignment.center,
            tapBodyToCollapse: true,
            tapBodyToExpand: true,
          ),
        ),
      ),
    );
  }
}

class MangaPageAppBarDetail extends StatelessWidget {
  final double expandedHeight;
  final Manga manga;
  final String tag;

  const MangaPageAppBarDetail({
    super.key,
    required this.expandedHeight,
    required this.manga,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Opacity(
          opacity: .8,
          child: Hero(
            tag: "${manga.id} $tag",
            child: CachedNetworkImage(
              imageUrl: manga.coverUrl,
              width: 120,
              fit: BoxFit.contain,
              alignment: Alignment.center,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  const Center(child: Skeleton(color: Colors.white)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 250,
              child: GenresWrap(
                manga: manga,
              ),
            ),
            Hero(
              tag: "${manga.id}_status $tag",
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding / 2),
                  child: Text(manga.status.name),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
