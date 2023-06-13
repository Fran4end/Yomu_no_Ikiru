import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../model/manga.dart';
import 'manga_page_background.dart';
import 'manga_page_detail.dart';
import 'top_buttons.dart';

class CustomSliverAppBar extends StatelessWidget {
  final bool save;
  final double expandedHeight;
  final Size screen;
  final String tag;
  final Manga manga;
  final Function()? rightButtonFunction;
  const CustomSliverAppBar({
    super.key,
    required this.save,
    this.expandedHeight = 380,
    required this.manga,
    required this.screen,
    required this.tag,
    this.rightButtonFunction,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      leading: Padding(
        padding: const EdgeInsets.all(defaultPadding / 2),
        child: TopButtonsFunctions(
          ic: const Icon(Icons.arrow_back_ios_new_rounded),
          function: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      expandedHeight: expandedHeight,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        collapseMode: CollapseMode.parallax,
        titlePadding: const EdgeInsets.symmetric(
            horizontal: defaultPadding * 4, vertical: defaultPadding / 2),
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
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        manga.author.toString(),
                        style: const TextStyle(
                            fontSize: 16, color: Colors.greenAccent, fontWeight: FontWeight.w200),
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
                        style: const TextStyle(
                            fontSize: 16, color: Colors.greenAccent, fontWeight: FontWeight.w200),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            MangaPageBackground(manga: manga),
            Positioned(
              top: kToolbarHeight + 50,
              child: MangaPageDetailAppBar(
                manga: manga,
                expandedHeight: expandedHeight,
                screen: screen,
                tag: tag,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding / 2),
          child: TopButtonsFunctions(
            ic: save
                ? const Icon(Icons.favorite_rounded)
                : const Icon(Icons.favorite_outline_rounded),
            function: rightButtonFunction,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(
          width: defaultPadding / 2,
        ),
      ],
    );
  }
}
