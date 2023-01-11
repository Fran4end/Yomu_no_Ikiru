import 'package:flutter/material.dart';
import 'package:manga_app/model/manga_builder.dart';
import 'package:manga_app/view/widgets/manga_widget.dart';
import '../../costants.dart';

class Recents extends StatelessWidget {
  const Recents({
    Key? key,
    required this.builders,
  }) : super(key: key);

  final List<MangaBuilder> builders;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: OrientationBuilder(
        builder: (context, orientation) => Padding(
          padding: const EdgeInsets.only(top: defaultPadding),
          child: AspectRatio(
            aspectRatio: orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 3)
                : (MediaQuery.of(context).size.width / 3) / MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Text(
                    'Recently updated',
                    style: titleStyle(),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (_, constraints) {
                      return ListView.builder(
                        itemCount: builders.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final manga = builders[index].build();
                          return SizedBox(
                            height: constraints.maxHeight * 0.2,
                            width: constraints.maxWidth * .5,
                            child: MangaCard(manga: manga, mangaBuilder: builders[index]),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
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

  final List<MangaBuilder> builders;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: OrientationBuilder(
        builder: (context, orientation) => Padding(
          padding: const EdgeInsets.only(top: defaultPadding / 2),
          child: AspectRatio(
            aspectRatio: orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 3)
                : (MediaQuery.of(context).size.width / 3) / MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Populars',
                          style: titleStyle().copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: LayoutBuilder(
                  builder: (_, constraints) {
                    return ListView.builder(
                      itemCount: builders.length,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(top: defaultPadding / 2, left: defaultPadding),
                      itemBuilder: (_, index) {
                        final manga = builders[index].build();
                        return SizedBox(
                          height: constraints.maxHeight,
                          width: constraints.maxWidth * .475,
                          child: MangaCard(manga: manga, mangaBuilder: builders[index]),
                        );
                      },
                    );
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
