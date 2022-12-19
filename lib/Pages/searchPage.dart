import 'dart:async';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/costants.dart';
import 'package:manga_app/manga.dart';
import 'package:manga_app/mangaworld.dart';
import 'package:manga_app/skeleton.dart';

Widget? _mangas;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    if (_mangas == null) {
      MangaWorld().getLastAdd().then((value) {
        _mangas = MangaGrid(
          listManga: _generateListManga(value),
        );
        setState(() {});
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Discover',
          style: titleStyle(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: Delegate(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: _mangas == null
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.8),
                crossAxisSpacing: defaultPadding * 2.5,
              ),
              itemBuilder: (context, index) => const CardSkelton(),
            )
          : RefreshIndicator(
              onRefresh: () => _refresh(),
              child: _mangas!,
            ),
    );
  }

  Future _refresh() async {
    MangaWorld().getLastAdd().then((value) {
      _mangas = MangaGrid(
        listManga: _generateListManga(value),
      );
      setState(() {});
    });
    _mangas = null;
    setState(() {});
  }

  List<Manga> _generateListManga(Map map) {
    List<Manga> mangas = [];
    map.forEach((key, value) {
      if (key.toString().contains("last")) {
        mangas.add(Manga(builder: value));
      }
    });
    return mangas;
  }
}

class Delegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear),
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    String search = query.trim().toLowerCase();
    return FutureBuilder(
      future: MangaWorld().getResults(search),
      builder: (context, snapshot) {
        Widget grid = const Center(child: Text(''));
        if (snapshot.hasData) {
          grid = MangaGrid(
            listManga: snapshot.data!,
          );
        } else {
          grid = const Center(child: Text(''));
        }
        return grid;
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Completer<List<String>> completer = Completer();
    String search = query.trim().toLowerCase();
    late final Debouncer debouncer =
        Debouncer(const Duration(milliseconds: 300), initialValue: '',
            onChanged: (value) {
      completer.complete(
          MangaWorld().buildSuggestions(value)); // call the API endpoint
    });

    debouncer.value = search;
    completer = Completer();

    return FutureBuilder(
        future: completer.future,
        builder: (context, snapshot) {
          List<String> suggestions = [];
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occured',
                  style: const TextStyle(fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {
              suggestions = snapshot.data!;
              return ListView.builder(
                itemCount: suggestions.length >= 5 ? 5 : suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return ListTile(
                    title: Text(suggestion),
                    onTap: () => query = suggestion,
                  );
                },
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
