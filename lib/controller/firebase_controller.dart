import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import '../model/file_manager.dart';
import '../model/manga_builder.dart';
import '../model/utils.dart';

class FirebaseController {
  static User? user = FirebaseAuth.instance.currentUser;

  static Future uploadJson(File file) async {
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (kDebugMode) {
        print('user not logged or file not valid');
      }
      return;
    } else {
      if (file.existsSync()) {
        String title = basename(file.path);
        final ref = FirebaseStorage.instance.ref().child('${user?.uid}/$title');
        ref.getDownloadURL().then((value) {
          //TODO: pop up for choose loacal update or remote
        }).onError((e, stackTrace) {
          if (kDebugMode) {
            print(e);
          }
          ref.putFile(file);
        });
      }
    }
  }

  static Future isOnLibrary(String title) async {
    user = FirebaseAuth.instance.currentUser;
    if (user == null || title == '') {
      if (kDebugMode) {
        print('user not logged or file not valid');
      }
    } else {
      List<MangaBuilder> builders = await FileManager.readAllLocalFile();
      try {
        return builders.firstWhere((element) => element.title == title);
      } catch (e) {
        if (kDebugMode) {
          print(e);
          return false;
        }
      }
    }
    return false;
  }

  static Future<List<Reference>> downloadJson() async {
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (kDebugMode) {
        print('user not logged');
      }
      return [];
    } else {
      try {
        final list = await FirebaseStorage.instance.ref().child('${user?.uid}/').listAll();
        return list.items;
      } on FirebaseException catch (e) {
        Utils.showSnackBar(e.message);
      }
      return [];
    }
  }
}
