import 'package:flutter/material.dart';
import 'package:manga_app/mangaworld.dart';
import 'package:manga_app/model/manga_builder.dart';
import 'package:manga_app/view/widgets/skeleton.dart';

import '../../costants.dart';
import '../widgets/home_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MangaBuilder> popular = [];
  List<MangaBuilder> recent = [];

  @override
  void initState() {
    super.initState();
    MangaWorld().getHomePageDocument().then(
      (document) async {
        MangaWorld().all(document).then((value) {
          if (mounted) {
            setState(() {
              popular = value['populars']!;
              recent = value['latests']!;
            });
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Home Page',
          style: titleStyle(),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            Popular(builders: popular.isEmpty ? [] : popular),
            Recents(builders: recent.isEmpty ? [] : recent)
          ],
        ),
      ),
    );
  }
}
