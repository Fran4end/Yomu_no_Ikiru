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
          listManga: value,
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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Discover',
          style: titleGreenStyle(),
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
          : _mangas!,
    );
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
    String search = query.trim().toLowerCase();
    return FutureBuilder(
      future: MangaWorld().buildSuggestions(search),
      builder: (context, snapshot) {
        List<String> suggestions = [];
        if (snapshot.connectionState == ConnectionState.done) {
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
        } else {
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
      },
    );
  }
}
