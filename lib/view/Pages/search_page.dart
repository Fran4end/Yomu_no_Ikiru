import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:yomu_no_ikiru/Api/Adapter/mangadex_adapter.dart';
import 'package:yomu_no_ikiru/Api/Adapter/mangaworld_adapter.dart';
import 'package:yomu_no_ikiru/Api/adapter.dart';
import 'package:yomu_no_ikiru/view/widgets/source_selector.dart';

import '../../constants.dart';
import '../../model/manga_builder.dart';
import '../widgets/manga_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final textController = TextEditingController();
  late String search;
  final PagingController<int, MangaBuilder> pagingController = PagingController(
    firstPageKey: 1,
    invisibleItemsThreshold: 8,
  );
  late final StreamSubscription subscription;
  MangaApiAdapter api = MangaWorldAdapter();
  final sources = [
    SourceSelector(
      sourceName: "MangaWorld",
      imagePath: "assets/sourceIcons/MangaWorld.png",
      mangaApi: MangaWorldAdapter(),
    ),
    SourceSelector(
      sourceName: "MangaDex",
      imagePath: "assets/sourceIcons/MangaDex.png",
      mangaApi: MangaDexAdapter(),
    ),
  ];

  @override
  void initState() {
    pagingController.addPageRequestListener((page) {
      _fetchData(page);
    });
    subscription = Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if ((connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi) &&
          pagingController.itemList!.isEmpty) {
        pagingController.refresh();
      }
    });
    super.initState();
    textController.text = '';
    search = "";
  }

  @override
  void dispose() {
    super.dispose();
    pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Discover',
        ),
        actions: [
          PopupMenuButton(
              icon: const Icon(FontAwesomeIcons.filter),
              onSelected: (value) {
                api = value;
                setState(() {});
                pagingController.refresh();
              },
              itemBuilder: (context) {
                List<PopupMenuItem<MangaApiAdapter>> items = [];
                for (SourceSelector source in sources) {
                  items.add(PopupMenuItem(value: source.mangaApi, child: source));
                }
                return items;
              }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => pagingController.refresh()),
        child: Column(
          children: [
            Container(
              height: 50,
              margin: const EdgeInsets.all(defaultPadding),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  suffix: IconButton(
                      onPressed: () {
                        textController.text = '';
                        search = "";
                        pagingController.refresh();
                      },
                      icon: const Icon(Icons.clear_rounded)),
                ),
                onChanged: (query) {
                  search = query.trim().toLowerCase();
                  pagingController.refresh();
                },
              ),
            ),
            Expanded(
              child: MangaGrid(
                pagingController: pagingController,
                api: api,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _fetchData(int page) async {
    try {
      final newItems = await api.getResults(search, page);
      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        pagingController.appendPage(newItems, ++page);
      }
    } catch (e) {
      pagingController.error = e;
    }
  }
}
