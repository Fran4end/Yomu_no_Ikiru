import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'manga.dart';
import 'manga_builder.dart';

class FileManag {
  static User? user = FirebaseAuth.instance.currentUser;

  static Future<List<File>> downloadAllFile(List<Reference> refs) async {
    List<File> files = [];
    for (var ref in refs) {
      try {
        final file = await downloadFile(ref);
        files.add(file);
      } on Exception catch (e) {
        print(e);
      }
    }
    return files;
  }

  static Future<File> downloadFile(Reference ref) async {
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/${user?.displayName}/${ref.name}');
    await ref.writeToFile(file);
    return file;
  }

  static Future<List<MangaBuilder>> readAllFile(List<File> files) async {
    List<MangaBuilder> builders = [];
    for (var file in files) {
      final builder = await readFile(file);
      builders.add(builder);
    }
    return builders;
  }

  static Future<MangaBuilder> readFile(File file) async {
    final content = await file.readAsString();
    final json = jsonDecode(content);
    MangaBuilder builder = MangaBuilder()
      ..titleImageLink = [json['title'], json['image'], json['link']]
      ..status = json['status']
      ..index = json['index']
      ..pageIndex = json['pageIndex'];

    return builder;
  }

  static Future<List<MangaBuilder>> readAllLocalFile() async {
    Directory dir = await getApplicationDocumentsDirectory();
    try {
      List<File> files =
          Directory("${dir.path}/${user?.uid}").listSync().map((e) => (e as File)).toList();
      return readAllFile(files);
    } on Exception catch (e) {
      print(e);
      return [];
    }
  }

  static Future<File> createFile(String title) async {
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/${user?.uid}/$title.json');
    return await file.create(recursive: true);
  }

  static Future<File> writeFile(MangaBuilder builder) async {
    user = FirebaseAuth.instance.currentUser;
    Manga manga = builder.build();
    Directory dir = await getApplicationDocumentsDirectory();
    File jsonFile = File('${dir.path}/${user?.uid}/${builder.title}.json');
    bool fileExist = await jsonFile.exists();
    Map<String, dynamic> jsonFileContent = manga.toJson();
    if (!fileExist) {
      jsonFile = await createFile(builder.title);
    }
    await jsonFile.writeAsString(jsonEncode(jsonFileContent));
    return jsonFile;
  }

  static void deleteFile(String title) async {
    user = FirebaseAuth.instance.currentUser;
    Directory dir = await getApplicationDocumentsDirectory();
    File jsonFile = File('${dir.path}/${user?.uid}/$title.json');
    bool fileExist = await jsonFile.exists();
    if (user == null) {
      if (kDebugMode) {
        print('user not logined');
      }
    } else {
      final ref = FirebaseStorage.instance.ref('${user?.uid}/$title.json');
      try {
        await ref.delete();
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    if (fileExist) {
      await jsonFile.delete();
    }
  }
}
