import 'dart:async';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../mangaworld.dart';
import '../widgets/skeleton.dart';
import '../widgets/manga_widget.dart';

Widget? _manga;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();

  @override
  void initState() {
    if (_manga == null) {
      super.initState();
      controller.text = '';
      getResult(controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Discover',
          style: titleStyle(),
        ),
      ),
      body: Center(
        child: OrientationBuilder(builder: (context, orientation) {
          return Column(
            children: [
              Container(
                height: 50,
                margin: EdgeInsets.all(
                    orientation == Orientation.portrait ? defaultPadding : defaultPadding / 2),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: "Search",
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    suffix: IconButton(
                        onPressed: () {
                          controller.text = '';
                          getResult(controller.text);
                        },
                        icon: const Icon(Icons.clear_rounded)),
                  ),
                  onChanged: (query) {
                    String search = query.trim().toLowerCase();
                    getResult(search);
                  },
                ),
              ),
              Expanded(
                child: _manga == null
                    ? const SkeletonGrid()
                    : SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: RefreshIndicator(
                          onRefresh: () => _refresh(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 230,
                            child: _manga!,
                          ),
                        ),
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }

  getResult(String query) {
    MangaWorld.getResults(query).then(
      (value) {
        _manga = MangaGrid(listManga: value);
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Future _refresh() async {
    if (mounted) {
      setState(() => _manga = null);
    }
    controller.text = '';
    getResult(controller.text);
  }
}
