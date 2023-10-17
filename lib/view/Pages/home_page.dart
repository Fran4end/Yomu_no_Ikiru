import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../mangaworld.dart';
import '../widgets/home_widget.dart';

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
    document = MangaWorld().getPageDocument();
    subscription = Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        if (mounted) {
          setState(() {});
        }
      }
    });
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
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => setState(() {
              document = MangaWorld().getPageDocument();
            })),
        child: FutureBuilder(
            future: document,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final manga = MangaWorld().all(snapshot.data!);
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
      ),
    );
  }
}
