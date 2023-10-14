import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../mangaworld.dart';
import '../../model/manga_builder.dart';
import '../widgets/skeleton.dart';
import '../widgets/manga_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final textController = TextEditingController();
  late String search;
  List<MangaBuilder>? builders;
  int page = 1;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    textController.text = '';
    search = "";
    scrollController.addListener(_scrollListener);
    _fetchData();
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
        onRefresh: _fetchData,
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
                        _fetchData();
                        textController.text = '';
                        search = "";
                      },
                      icon: const Icon(Icons.clear_rounded)),
                ),
                onChanged: (query) {
                  search = query.trim().toLowerCase();
                  _fetchData();
                },
              ),
            ),
            Expanded(
              child: builders == null
                  ? const SkeletonGrid()
                  : MangaGrid(
                      listManga: builders!,
                      scrollController: scrollController,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent - 300 &&
        !scrollController.position.outOfRange) {
      setState(() {
        _fetchData(true);
      });
    }
  }

  Future _fetchData([bool add = false]) async {
    if (add) {
      page = page + 1;
      final content = await MangaWorld.getResults(search, builders ?? [], page);
      builders!.addAll(content);
    } else {
      page = 1;
      final content = await MangaWorld.getResults(search, builders ?? [], page);
      builders = content;
    }
    if (mounted) {
      setState(() {});
    }
  }
}
