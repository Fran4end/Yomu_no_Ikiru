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
  final controller = TextEditingController();
  late String search;
  List<MangaBuilder>? builders;

  @override
  void initState() {
    super.initState();
    controller.text = '';
    search = "";
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
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
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: Column(
          children: [
            Container(
              height: 50,
              margin: const EdgeInsets.all(defaultPadding),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  suffix: IconButton(
                      onPressed: () {
                        controller.text = '';
                        search = "";
                        fetchData();
                      },
                      icon: const Icon(Icons.clear_rounded)),
                ),
                onChanged: (query) {
                  search = query.trim().toLowerCase();
                  fetchData();
                },
              ),
            ),
            Expanded(
              child: builders == null ? const SkeletonGrid() : MangaGrid(listManga: builders!),
            ),
          ],
        ),
      ),
    );
  }

  Future fetchData() async {
    final content = await MangaWorld.getResults(search, builders == null ? [] : builders!);
    builders = content;

    if (mounted) {
      setState(() {});
    }
  }
}
