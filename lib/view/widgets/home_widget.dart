import 'package:flutter/material.dart';
import 'package:yomu_no_ikiru/Api/Adapter/mangaworld_adapter.dart';
import '../../constants.dart';
import '../../model/manga_builder.dart';
import 'manga_widget.dart';
import 'skeleton.dart';

class Recent extends StatelessWidget {
  const Recent({
    super.key,
    required this.builders,
  });

  final List<MangaBuilder>? builders;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: defaultPadding, left: defaultPadding),
              child: Text(
                'Recently updated',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 200,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (builders != null && builders!.isNotEmpty) {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: builders!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return AspectRatio(
                          aspectRatio: .9,
                          child: MangaCard(
                            mangaBuilder: builders![index],
                            tag: 'recent$index',
                            api: MangaWorldAdapter(),
                          ),
                        );
                      },
                    );
                  } else if (builders == null) {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          const AspectRatio(aspectRatio: .9, child: CardSkelton(aspectRatio: .9)),
                    );
                  } else {
                    return const Center();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Popular extends StatelessWidget {
  const Popular({
    super.key,
    required this.builders,
  });

  final List<MangaBuilder>? builders;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: defaultPadding / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Row(
                children: [
                  Text(
                    'Popular',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 280,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (builders != null && builders!.isNotEmpty) {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: builders!.length,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(top: defaultPadding / 2, left: defaultPadding),
                      itemBuilder: (_, index) {
                        return AspectRatio(
                          aspectRatio: .7,
                          child: MangaCard(
                            mangaBuilder: builders![index],
                            tag: 'popular$index',
                            maxLineText: 2,
                            aspectRatio: 0.7,
                            api: MangaWorldAdapter(),
                          ),
                        );
                      },
                    );
                  } else if (builders == null) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          const AspectRatio(aspectRatio: .7, child: CardSkelton(aspectRatio: .7)),
                    );
                  } else {
                    return const Center();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
