import 'dart:io';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:manga_app/costants.dart';
import 'package:manga_app/model/chaper.dart';
import 'package:manga_app/model/manga_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'manga.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static User? user = FirebaseAuth.instance.currentUser;

  static List<Manga> generateListManga(List<MangaBuilder>? builders) {
    List<Manga> mangas = [];
    if (builders == null) {
      return mangas;
    }
    for (var builder in builders) {
      mangasBuilder.update(builder.title, (value) => builder, ifAbsent: () => builder);
      Manga manga = builder.build();
      mangas.add(manga);
    }
    return mangas;
  }

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
      try {
        final ref = FirebaseStorage.instance.ref('${user?.uid}$path');
        final list = await ref.listAll();
        return list.items;
      } on FirebaseException catch (e) {
        showSnackBar(e.message);
      }
      return [];
    }
  }

  static MangaBuilder getMangaBuilderFromTitle(String title) {
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
