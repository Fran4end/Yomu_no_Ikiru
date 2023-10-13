import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants.dart';
import '../../controller/firebase_controller.dart';
import '../../controller/file_manager.dart';
import '../../model/manga_builder.dart';
import '../../controller/utils.dart';
import '../widgets/manga_widget.dart';
import '../widgets/skeleton.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<StatefulWidget> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Future<List<MangaBuilder>> futureBuilders = FileManager.readAllLocalFile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Library',
        ),
        actions: [
          IconButton(
            onPressed: _syncLibrary,
            icon: const Icon(Icons.cloud_sync_rounded),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.only(top: defaultPadding),
          child: FutureBuilder(
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
                      return builders.isEmpty
                          ? const Center(child: Text('Nothing added to library'))
                          : MangaGrid(
                              listManga: builders,
                              save: true,
                              tag: "library",
                            );
                    }
                }
              }),
        ),
      ),
    );
  }

  Future _refresh() async {
    setState(() {
      futureBuilders = FileManager.readAllLocalFile();
    });
  }

  Future _syncLibrary() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Directory dir = await getApplicationDocumentsDirectory();
      try {
        List<File> files =
            Directory("${dir.path}/${user.uid}").listSync().map((e) => (e as File)).toList();
        for (var file in files) {
          if (context.mounted) {
            await FirebaseController.uploadJson(file, context);
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("Line 97: $e");
        }
      } finally {
        FirebaseController.downloadJson()
            .then((refs) => FileManager.downloadAllFile(refs).then((files) {
                  if (mounted) {
                    setState(() {
                      futureBuilders = FileManager.readAllLocalFile();
                    });
                  }
                }));
      }
    } else {
      Utils.showSnackBar('You need to login before sync all manga');
    }
  }
}
