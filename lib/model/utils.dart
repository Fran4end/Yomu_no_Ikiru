import 'dart:convert';
import 'dart:io';
import 'package:manga_app/costants.dart';
import 'package:manga_app/model/chaper.dart';
import 'package:manga_app/model/manga_builder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'manga.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  UploadTask? uploadTask;

  static showSnackBar(String? text) {
    if (text == null) return;
    final snackBar = SnackBar(content: Text(text));

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Future uploadJson(File file, User? user) async {
    if (user == null) {
      print('user not logined');
      return;
    }
    final path = '${user.uid}/data.json';

    if (file.existsSync()) {
      final ref = FirebaseStorage.instance.ref().child(path);
      ref.putFile(file);
      final snapshot = await uploadTask?.whenComplete(() {});
      final urlDownload = await snapshot?.ref.getDownloadURL();
      print('Download link: $urlDownload');
    }
  }

  Future<File> createFile(User? user) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String appDocPath = dir.path;
    File file = File('$appDocPath/${user?.displayName}/data.json');
    return await file.create(recursive: true);
  }

  Future<File> writeFile(String title, User? user) async {
    Manga manga = getMangaBuilderFromTitle(title)!.build();
    Directory dir = await getApplicationDocumentsDirectory();
    File jsonFile = File('${dir.path}/${user?.displayName}/data.json');
    bool fileExist = await jsonFile.exists();
    Map<String, dynamic> jsonFileContent = {};
    if (fileExist) {
      try {
        jsonFileContent = jsonDecode(await jsonFile.readAsString());
      } on Exception catch (e) {
        print(e);
        jsonFileContent = {};
      }
    } else {
      jsonFile = await createFile(user);
    }

    jsonFileContent.addAll({manga.title.toString(): manga});
    await jsonFile.writeAsString(jsonEncode(jsonFileContent));
    return jsonFile;
  }

  MangaBuilder? getMangaBuilderFromTitle(String title) {
    String t = title.replaceAll(RegExp(r'[^\sa-zA-Z]'), '');
    t = t.replaceAll('Capitolo', '');
    print(t);
    return mangasBuilder[t];
  }

  void saveBookmark(int index, int pageIndex, Chapter chapter) {
    MangaBuilder? builder = getMangaBuilderFromTitle(chapter.title);
    print('$pageIndex || $index');
    builder!
      ..index = index
      ..pageIndex = pageIndex;
    mangasBuilder.update(builder.title, (value) => builder);
  }
}
