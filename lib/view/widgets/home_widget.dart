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
                child: ListView.builder(
                  itemCount: builders.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return MangaCard(
                      mangaBuilder: builders[index],
                      tag: 'recent',
                      iHeight: orientation == Orientation.portrait ? 160 : 370,
                      iWidth: orientation == Orientation.portrait ? 140 : 320,
                    );
                  },
                ),
              ),
            ],
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Row(
                  children: [
                    Text(
                      'Populars',
                      style: titleStyle().copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 280,
                child: ListView.builder(
                  itemCount: builders.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(top: defaultPadding / 2, left: defaultPadding),
                  itemBuilder: (_, index) {
                    return MangaCard(
                      mangaBuilder: builders[index],
                      tag: 'popular',
                      iHeight: orientation == Orientation.portrait ? 200 : 370,
                      iWidth: orientation == Orientation.portrait ? 140 : 320,
                      bottomText: 80,
                      maxLineText: 3,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
