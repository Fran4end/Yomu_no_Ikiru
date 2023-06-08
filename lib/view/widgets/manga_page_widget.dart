import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/view/widgets/genres_wrap.dart';
import 'package:manga_app/view/widgets/skeleton.dart';
import 'package:manga_app/view/widgets/top_buttons.dart';

import '../../constants.dart';
import '../../model/manga.dart';

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Manga manga;
  final String mangaImage;
  final Size screen;
  final double expandedHeight;
  final bool save;
  final String tag;
  final Function()? rightButtonFunction;
  CustomSliverAppBarDelegate({
    required this.manga,
    required this.mangaImage,
    required this.screen,
    required this.expandedHeight,
    required this.save,
    required this.tag,
    required this.rightButtonFunction,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        buildBackground(shrinkOffset, screen, mangaImage),
        buildAppBar(shrinkOffset, context, rightButtonFunction),
        Positioned(
          bottom: expandedHeight - expandedHeight,
          child: buildDetail(screen, shrinkOffset),
        ),
      ],
    );
  }

  Widget buildDetail(Size screen, double shrinkOffset) {
    return Opacity(
      opacity: disappear(shrinkOffset).isNegative ? 0 : disappear(shrinkOffset),
      child: SizedBox(
        width: screen.width - 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GenresWrap(manga: manga),
            Container(
              padding: const EdgeInsets.all(defaultPadding),
              width: (screen.width - 20) / 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 22.0,
                      ),
                      const SizedBox(width: defaultPadding / 2),
                      Text(
                        manga.vote.toString(),
                        style: subtitleStyle(),
                      ),
                      const SizedBox(width: defaultPadding / 2),
                      Text(
                        '(${manga.readings})',
                        style: miniStyle(),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar(double shrinkOffset, BuildContext context, Function()? function) => Opacity(
        opacity: 0.8,
        child: AppBar(
          centerTitle: true,
          titleTextStyle: titleStyle(),
          leading: Padding(
            padding: const EdgeInsets.all(defaultPadding / 2),
            child: TopButtonsFunctions(
              ic: const Icon(Icons.arrow_back_ios_new_rounded),
              function: () => Navigator.of(context).pop(),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding / 2),
              child: TopButtonsFunctions(
                ic: save
                    ? const Icon(Icons.favorite_rounded)
                    : const Icon(Icons.favorite_outline_rounded),
                function: function,
              ),
            ),
            const SizedBox(
              width: defaultPadding / 2,
            ),
          ],
          title: FittedBox(
            fit: BoxFit.contain,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      manga.title.toString(),
                      style: titleStyle(),
                      textAlign: TextAlign.center,
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          manga.author.toString(),
                          style: subtitleStyle(),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                          child: CircleAvatar(
                            radius: 3,
                            backgroundColor: Colors.black,
                          ),
                        ),
                        Text(
                          manga.artist.toString(),
                          style: subtitleStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildBackground(double shrinkOffset, Size screen, String image) => Hero(
      tag: tag,
      child: SizedBox(
        width: screen.width,
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              const Center(child: Skeleton(color: Colors.white)),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ));

  double disappear(double shrinkOffset) => 1 - (shrinkOffset / .7) / expandedHeight;

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
