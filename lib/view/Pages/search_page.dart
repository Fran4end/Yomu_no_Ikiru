import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../constants.dart';
import '../../mangaworld.dart';
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
  final PagingController<int, MangaBuilder> pagingController = PagingController(firstPageKey: 1);
  late final StreamSubscription subscription;

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
              child: MangaGrid(pagingController: pagingController),
            ),
          ],
        ),
      ),
    );
  }

  Future _fetchData(int page) async {
    try {
      final newItems = await MangaWorld.getResults(search, page);
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
