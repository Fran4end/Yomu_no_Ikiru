import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Api/Apis/mangaworld.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final StreamSubscription subscription;
  late Future document;
  @override
  void initState() {
    super.initState();
    document = MangaWorld().getPageDocument("");
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home Page',
          ),
          actions: [
            IconButton(
              icon: const Icon(FontAwesomeIcons.bug),
              onPressed: () async {},
            ),
          ],
        ),
        body: const Center(child: Text("coming soon.."))
        /*RefreshIndicator(
        onRefresh: () => Future.sync(() => setState(() {
              document = MangaWorld().getPageDocument("");
            })),
        child: FutureBuilder(
            future: document,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final manga = MangaWorld().getLatestsAndPopular(snapshot.data!);
                return CustomScrollView(
                  slivers: [
                    Popular(builders: manga["popular"]),
                    Recent(builders: manga["latests"]),
                  ],
                );
              } else {
                return const CustomScrollView(
                  slivers: [
                    Popular(builders: null),
                    Recent(builders: null),
                  ],
                );
              }
            }),
      ),*/
        );
  }
}
