import 'package:flutter/material.dart';
import 'package:manga_app/model/manga_builder.dart';
import 'package:manga_app/view/widgets/manga_widget.dart';
import '../../constants.dart';
import 'skeleton.dart';

class Recent extends StatelessWidget {
  const Recent({
    Key? key,
    required this.builders,
  }) : super(key: key);

  final List<MangaBuilder>? builders;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: defaultPadding, left: defaultPadding),
              child: Text(
                'Recently updated',
                style: titleStyle().copyWith(fontWeight: FontWeight.bold),
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
                          aspectRatio: 0.9,
                          child: MangaCard(
                            mangaBuilder: builders![index],
                            tag: 'recent$index',
                          ),
                        );
                      },
                    );
                  } else if (builders != null) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => const CardSkelton(),
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
    Key? key,
    required this.builders,
  }) : super(key: key);

  final List<MangaBuilder>? builders;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: defaultPadding / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Row(
                children: [
                  Text(
                    'Popular',
                    style: titleStyle().copyWith(fontWeight: FontWeight.bold),
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
                          aspectRatio: 0.7,
                          child: MangaCard(
                            mangaBuilder: builders![index],
                            tag: 'popular$index',
                            maxLineText: 2,
                            aspectRatio: 0.7,
                          ),
                        );
                      },
                    );
                  } else if (builders != null) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => const CardSkelton(),
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
