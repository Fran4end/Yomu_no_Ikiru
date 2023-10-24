import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:yomu_no_ikiru/Api/adapter.dart';

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
    required this.api,
  }) : super(key: key);

  final MangaBuilder mangaBuilder;
  final bool save;
  final String tag;
  final double maxLineText, aspectRatio;
  final MangaApiAdapter api;

  @override
  Widget build(BuildContext context) {
    Manga manga = mangaBuilder.build();
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MangaPage(
          mangaBuilder: mangaBuilder,
          save: save,
          tag: "${manga.id} $tag",
          api: api,
        ),
      )),
      child: Stack(
        // clipBehavior: Clip.none,
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
                              imageUrl: manga.image,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  const Center(child: Skeleton(color: Colors.white)),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(defaultPadding / 3),
                            child: Text(manga.status),
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
                child: AutoSizeText(
                  manga.title,
                  maxLines: maxLineText.toInt(),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  minFontSize: 16,
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
    Key? key,
    required this.pagingController,
    this.axisCount = 2,
    this.save = false,
    this.tag = "grid",
    this.api,
  }) : super(key: key);

  final bool save;
  final int axisCount;
  final String tag;
  final PagingController<int, MangaBuilder> pagingController;
  final MangaApiAdapter? api;

  @override
  Widget build(BuildContext context) {
    return PagedGridView(
      pagingController: pagingController,
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      showNewPageProgressIndicatorAsGridChild: false,
      showNewPageErrorIndicatorAsGridChild: false,
      showNoMoreItemsIndicatorAsGridChild: false,
      builderDelegate: PagedChildBuilderDelegate(
        firstPageProgressIndicatorBuilder: (_) =>
            const SizedBox(height: 200, child: SkeletonGrid()),
        newPageProgressIndicatorBuilder: (_) => const SizedBox(height: 200, child: SkeletonGrid()),
        transitionDuration: const Duration(milliseconds: 500),
        animateTransitions: true,
        itemBuilder: (context, MangaBuilder manga, index) => MangaCard(
          mangaBuilder: manga,
          save: save,
          tag: "$tag$index",
          api: api ?? manga.api,
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: axisCount,
        childAspectRatio: .9,
      ),
    );
  }
}
