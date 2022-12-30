import 'package:flutter/material.dart';
import 'package:manga_app/model/manga_builder.dart';

import '../../costants.dart';
import '../../model/manga.dart';
import '../../model/utils.dart';
import '../widgets/manga_widget.dart';
import '../widgets/skeleton.dart';

Future<List<MangaBuilder>>? futureBuilders;

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<StatefulWidget> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  void initState() {
    super.initState();
    Utils.downloadJson().then((refs) => Utils.downloadAllFile(refs).then((files) {
          if (mounted) {
            setState(() {
              futureBuilders = Utils.readAllFile(files);
            });
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: futureBuilders == null
            ? OrientationBuilder(
                builder: (context, orientation) => GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 200,
                        crossAxisCount: 2,
                        childAspectRatio: orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.width /
                                (MediaQuery.of(context).size.height / 2)
                            : (MediaQuery.of(context).size.width / 2) /
                                MediaQuery.of(context).size.height,
                        crossAxisSpacing: defaultPadding * 1.5,
                        mainAxisSpacing:
                            orientation == Orientation.portrait ? defaultPadding / 2 : 2,
                      ),
                      itemBuilder: (context, index) => const CardSkelton(),
                    ))
            : FutureBuilder(
                future: futureBuilders,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return OrientationBuilder(
                          builder: (context, orientation) => GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisExtent: 200,
                                  crossAxisCount: 2,
                                  childAspectRatio: orientation == Orientation.portrait
                                      ? MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height / 2)
                                      : (MediaQuery.of(context).size.width / 2) /
                                          MediaQuery.of(context).size.height,
                                  crossAxisSpacing: defaultPadding * 1.5,
                                  mainAxisSpacing:
                                      orientation == Orientation.portrait ? defaultPadding / 2 : 2,
                                ),
                                itemBuilder: (context, index) => const CardSkelton(),
                              ));
                    default:
                      if (snapshot.hasError) {
                        return const Center(child: Text('Something went wrong'));
                      } else {
                        final builders = snapshot.data!;
                        if (builders.isEmpty) {
                          return const Center(child: Text('Nothig added to library'));
                        }
                        return RefreshIndicator(
                          onRefresh: _refresh,
                          child: MangaGrid(
                            listManga: _generateListManga(builders),
                            save: true,
                          ),
                        );
                      }
                  }
                }),
      ),
    );
  }

  List<Manga> _generateListManga(List<MangaBuilder>? builders) {
    List<Manga> mangas = [];
    if (builders == null) {
      return mangas;
    }
    for (var builder in builders) {
      mangasBuilder.update(builder.title, (value) => builder, ifAbsent: () => builder);
      Manga manga = builder.build();
      mangas.add(manga);
    }
    return mangas;
  }

  Future _refresh() async {
    Utils.downloadJson().then((refs) => Utils.downloadAllFile(refs).then((files) => setState(() {
          futureBuilders = Utils.readAllFile(files);
        })));
  }
}
