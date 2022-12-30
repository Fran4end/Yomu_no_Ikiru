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
  static User? user = FirebaseAuth.instance.currentUser;

  static showSnackBar(String? text) {
    if (text == null) return;
    final snackBar = SnackBar(content: Text(text));

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Future uploadJson(File file, String title, [String path = '/']) async {
    user = FirebaseAuth.instance.currentUser;
    if (user == null || title == '') {
      print('user not logined or file not valid');
      return;
    } else {
      final filePath = '${user?.uid}/$path$title.json';
      if (file.existsSync()) {
        final ref = FirebaseStorage.instance.ref().child(filePath);
        ref.putFile(file);
      }
    }
  }

  static Future<List<Reference>> downloadJson([String path = '/']) async {
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('user not logined');
      return [];
    } else {
      final ref = FirebaseStorage.instance.ref('${user?.uid}$path');
      final list = await ref.listAll();
      return list.items;
    }
  }

  static Future<List<File>> downloadAllFile(List<Reference> refs) async {
    List<File> files = [];
    for (var ref in refs) {
      final file = await _downloadFile(ref);
      files.add(file);
    }
    return files;
  }

  static Future<File> _downloadFile(Reference ref) async {
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/${user?.displayName}/${ref.name}');
    await ref.writeToFile(file);
    return file;
  }

  static Future<List<MangaBuilder>> readAllFile(List<File> files) async {
    List<MangaBuilder> builders = [];
    for (var file in files) {
      final builder = await _readFile(file);
      builders.add(builder);
    }
    return builders;
  }

  static Future<MangaBuilder> _readFile(File file) async {
    final content = await file.readAsString();
    final json = jsonDecode(content);
    MangaBuilder builder = MangaBuilder()
      ..titleImageLink = [json['title'], json['image'], json['link']]
      ..status = json['status']
      ..index = json['index']
      ..pageIndex = json['pageIndex'];

    return builder;
  }

  Future<File> createFile(String title) async {
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/${user?.displayName}/$title.json');
    return await file.create(recursive: true);
  }

  Future<File> writeFile(String title) async {
    user = FirebaseAuth.instance.currentUser;
    Manga manga = getMangaBuilderFromTitle(title).build();
    Directory dir = await getApplicationDocumentsDirectory();
    File jsonFile = File('${dir.path}/${user?.displayName}/$title.json');
    bool fileExist = await jsonFile.exists();
    Map<String, dynamic> jsonFileContent = manga.toJsonOnlyBookmark();
    if (!fileExist) {
      jsonFile = await createFile(title);
    }
    await jsonFile.writeAsString(jsonEncode(jsonFileContent));
    return jsonFile;
  }

  void deleteFile(String title, [String path = '/']) async {
    user = FirebaseAuth.instance.currentUser;
    Directory dir = await getApplicationDocumentsDirectory();
    File jsonFile = File('${dir.path}/${user?.displayName}/$title.json');
    bool fileExist = await jsonFile.exists();
    if (user == null) {
      print('user not logined');
    } else {
      final ref = FirebaseStorage.instance.ref('${user?.uid}$path$title.json');
      try {
        await ref.delete();
      } catch (e) {
        print(e);
      }
    }
    if (fileExist) {
      await jsonFile.delete();
    }
  }

  MangaBuilder getMangaBuilderFromTitle(String title) {
    String t = title.replaceAll(RegExp(r'[^\sa-zA-Z]'), '');
    t = t.replaceAll('Capitolo', '').trim();
    if (mangasBuilder.containsKey(t)) {
      return mangasBuilder[t]!;
    }
    return mangasBuilder.values.first;
  }

  void saveBookmark(int index, int pageIndex, Chapter chapter) {
    MangaBuilder? builder = getMangaBuilderFromTitle(chapter.title);
    builder
      ..index = index
      ..pageIndex = pageIndex;
    mangasBuilder.update(builder.title, (value) => builder);
  }
}
