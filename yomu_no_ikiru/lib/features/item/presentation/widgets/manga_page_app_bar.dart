import 'package:flutter/material.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';
import 'package:yomu_no_ikiru/features/item/presentation/widgets/manga_page_background.dart';
import 'package:yomu_no_ikiru/features/item/presentation/widgets/manga_page_app_bar_detail.dart';
import 'package:yomu_no_ikiru/core/common/widgets/top_button.dart';

import '../../../../constants.dart';

/// Widget that displays the app bar for the manga page.
///
/// This widget is a [SliverAppBar] that displays the manga's title, author, and artist.
/// It also displays the manga's cover image as the background.
/// The app bar is pinned to the top of the screen.
/// The app bar also has a [TopButtonsFunctions] widget that displays a back button and a save button.
class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
    required this.save,
    required this.manga,
    required this.tag,
    this.expandedHeight = 380,
    this.rightButtonFunction,
  });

  final bool save;
  final double expandedHeight;
  final Function()? rightButtonFunction;
  final Manga manga;
  final String tag;
  final double artistAuthorSize = 12;

  @override
  Widget build(BuildContext context) {
    //final manga = ;
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
            horizontal: defaultPadding * 2, vertical: defaultPadding / 2),
        title: SafeArea(
          child: FittedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  manga.title.toString(),
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      manga.author.toString(),
                      style: TextStyle(fontSize: artistAuthorSize, fontWeight: FontWeight.w200),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                      child: CircleAvatar(
                        radius: 3,
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      manga.artist.toString(),
                      style: TextStyle(fontSize: artistAuthorSize, fontWeight: FontWeight.w200),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            MangaPageBackground(
              manga: manga,
            ),
            Positioned(
              top: kToolbarHeight + 50,
              child: MangaPageAppBarDetail(
                expandedHeight: expandedHeight,
                manga: manga,
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
          ),
        ),
        const SizedBox(
          width: defaultPadding / 2,
        ),
      ],
    );
  }
}
