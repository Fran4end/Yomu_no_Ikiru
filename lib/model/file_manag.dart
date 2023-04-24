import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'manga.dart';
import 'manga_builder.dart';

class FileManager {
  static User? user = FirebaseAuth.instance.currentUser;

  static Future<List<File>> downloadAllFile(List<Reference> refs) async {
    List<File> files = [];
    for (var ref in refs) {
      try {
        final file = await downloadFile(ref);
        files.add(file);
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    return files;
  }

  static Future<File> downloadFile(Reference ref) async {
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/${user?.uid}/${ref.name}');
    bool fileExist = await file.exists();
    if (!fileExist) {
      file = await createFile(ref.name.replaceAll(".json", ""));
    }
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
      ..fromJson = json
      ..save = true;
    return builder;
  }

  static Future<List<MangaBuilder>> readAllLocalFile() async {
    Directory dir = await getApplicationDocumentsDirectory();
    try {
      List<File> files =
          Directory("${dir.path}/${user?.uid}").listSync().map((e) => (e as File)).toList();
      return readAllFile(files);
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
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
    Directory dir = await getApplicationDocumentsDirectory();
    File jsonFile = File('${dir.path}/${user?.uid}/$title.json');
    bool fileExist = await jsonFile.exists();
    if (fileExist) {
      await jsonFile.delete();
    }
  }
}
