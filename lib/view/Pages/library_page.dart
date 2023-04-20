import 'package:flutter/material.dart';
import 'package:manga_app/model/file_manag.dart';
import 'package:manga_app/model/manga_builder.dart';

import '../../costants.dart';
import '../../model/utils.dart';
import '../widgets/manga_widget.dart';
import '../widgets/skeleton.dart';

Future<List<MangaBuilder>>? futureBuilders;

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<StatefulWidget> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  void initState() {
    super.initState();
    futureBuilders = FileManag.readAllLocalFile();
    // Utils.downloadJson().then((refs) => FileManag.downloadAllFile(refs).then((files) {
    //       if (mounted) {
    //         setState(() {
    //           futureBuilders = FileManag.readAllFile(files);
    //         });
    //       }
    //     }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Library',
          style: titleStyle(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: defaultPadding),
        child: futureBuilders == null
            ? const SkeletonGrid()
            : FutureBuilder(
                future: futureBuilders,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const SkeletonGrid();
                    default:
                      if (snapshot.hasError) {
                        return const Center(child: Text('Something went wrong'));
                      } else {
                        final builders = snapshot.data!;
                        return RefreshIndicator(
                          onRefresh: _refresh,
                          child: builders.isEmpty
                              ? const Center(child: Text('Nothig added to library'))
                              : MangaGrid(
                                  listManga: builders,
                                  save: true,
                                ),
                        );
                      }
                  }
                }),
      ),
    );
  }

  Future _refresh() async {
    Utils.downloadJson().then((refs) => FileManag.downloadAllFile(refs).then((files) {
          if (mounted) {
            setState(() {
              futureBuilders = FileManag.readAllFile(files);
            });
          }
        }));
  }
}
