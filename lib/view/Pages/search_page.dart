import 'dart:async';
import 'package:flutter/material.dart';

import '../../costants.dart';
import '../../manga.dart';
import '../../manga_builder.dart';
import '../../mangaworld.dart';
import '../widgets/skeleton.dart';
import '../widgets/manga_widget.dart';

Widget? _mangas;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin<SearchPage> {
  @override
  bool get wantKeepAlive => true;
  final controller = TextEditingController();

  @override
  void initState() {
    if (_mangas == null) {
      controller.text = '';
      MangaWorld().getHomePageDocument().then(
        (document) {
          MangaWorld().onlyLatests(document).then((value) {
            _mangas = MangaGrid(listManga: _generateListManga(value));
            setState(() {});
          });
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Discover',
          style: titleStyle(),
        ),
      ),
      body: Center(
        child: OrientationBuilder(builder: (context, orientation) {
          return Column(
            children: [
              Container(
                height: 50,
                margin: EdgeInsets.all(
                    orientation == Orientation.portrait ? defaultPadding : defaultPadding / 2),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: "Search",
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    suffix: IconButton(
                        onPressed: () {
                          controller.text = '';
                          MangaWorld().getResults('').then(
                            (value) {
                              _mangas = MangaGrid(listManga: value);
                              setState(() {});
                            },
                          );
                        },
                        icon: const Icon(Icons.clear_rounded)),
                  ),
                  onSubmitted: (value) {
                    if (value.isEmpty) {
                      MangaWorld().getHomePageDocument().then(
                        (document) {
                          MangaWorld().onlyLatests(document).then((value) {
                            _mangas = MangaGrid(listManga: _generateListManga(value));
                            setState(() {});
                          });
                        },
                      );
                    }
                  },
                  onChanged: (query) {
                    String search = query.trim().toLowerCase();
                    if (search.isNotEmpty) {
                      MangaWorld().getResults(search).then(
                        (value) {
                          _mangas = MangaGrid(listManga: value);
                          setState(() {});
                        },
                      );
                    } else {
                      MangaWorld().getHomePageDocument().then(
                        (document) {
                          MangaWorld().onlyLatests(document).then((value) {
                            _mangas = MangaGrid(listManga: _generateListManga(value));
                            setState(() {});
                          });
                        },
                      );
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: defaultPadding / 2),
                child: DividerWithText(
                  dividerText: "Chapters",
                ),
              ),
              Expanded(
                child: _mangas == null
                    ? OrientationBuilder(builder: (context, orientation) {
                        return GridView.builder(
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
                        );
                      })
                    : RefreshIndicator(
                        onRefresh: () => _refresh(),
                        child: _mangas!,
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future _refresh() async {
    MangaWorld().getHomePageDocument().then(
      (document) {
        MangaWorld().onlyLatests(document).then((value) {
          _mangas = MangaGrid(listManga: _generateListManga(value));
          setState(() {});
        });
      },
    );
    _mangas = null;
    setState(() {});
  }

  List<Manga> _generateListManga(List<MangaBuilder>? builders) {
    List<Manga> mangas = [];
    if (builders == null) {
      return mangas;
    }
    for (var builder in builders) {
      Manga manga = builder.build();
      mangas.add(manga);
    }
    return mangas;
  }
}

class DividerWithText extends StatelessWidget {
  final String dividerText;
  const DividerWithText({Key? key, required this.dividerText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(
            child: Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Divider(),
        )),
        Text(
          dividerText,
          style: subtitleStyle(),
        ),
        const Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Divider(),
        )),
      ],
    );
  }
}
