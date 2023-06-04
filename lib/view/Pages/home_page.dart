import 'package:flutter/material.dart';
import 'package:manga_app/mangaworld.dart';
import 'package:manga_app/model/manga_builder.dart';

import '../../constants.dart';
import '../widgets/home_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MangaBuilder>? popular = [];
  List<MangaBuilder>? recent = [];

  @override
  void initState() {
    super.initState();
    popular = [];
    recent = [];
    fetchData();
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
        child: RefreshIndicator(
          onRefresh: fetchData,
          child: CustomScrollView(
            slivers: [
              Popular(builders: popular),
              Recent(builders: recent),
            ],
          ),
        ),
      ),
    );
  }

  Future fetchData() async {
    final doc = await MangaWorld().getHomePageDocument();

    if (doc != null) {
      final content = await MangaWorld().all(doc);
      popular = content['popular']!;
      recent = content['latests']!;
    } else {
      popular = null;
      recent = null;
    }

    if (mounted) {
      setState(() {});
    }
  }
}
