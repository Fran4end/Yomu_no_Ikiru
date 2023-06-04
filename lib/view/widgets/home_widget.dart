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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (builders != null && builders!.isNotEmpty) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: builders!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return MangaCard(
                            mangaBuilder: builders![index],
                            tag: 'recent',
                            iHeight: orientation == Orientation.portrait ? 160 : 370,
                            iWidth: orientation == Orientation.portrait ? 140 : 320,
                          );
                        },
                      );
                    } else if (builders != null) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => CardSkelton(
                          iHeight: orientation == Orientation.portrait ? 160 : 370,
                          iWidth: orientation == Orientation.portrait ? 140 : 320,
                        ),
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
                        padding:
                            const EdgeInsets.only(top: defaultPadding / 2, left: defaultPadding),
                        itemBuilder: (_, index) {
                          return MangaCard(
                            mangaBuilder: builders![index],
                            tag: 'popular',
                            iHeight: orientation == Orientation.portrait ? 200 : 370,
                            iWidth: orientation == Orientation.portrait ? 140 : 320,
                            maxLineText: 3,
                          );
                        },
                      );
                    } else if (builders != null) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => CardSkelton(
                          iHeight: orientation == Orientation.portrait ? 200 : 370,
                          iWidth: orientation == Orientation.portrait ? 140 : 320,
                        ),
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
      ),
    );
  }
}
