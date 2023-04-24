import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:manga_app/model/file_manag.dart';
import 'package:path/path.dart';
import 'package:manga_app/model/manga_builder.dart';

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
        print(title);
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

  // static Future<MangaBuilder> getBuilder(String title) async {
  //   user = FirebaseAuth.instance.currentUser;
  //   if (user == null || title == '') {
  //     if (kDebugMode) {
  //       print('user not logined or file not valid');
  //     }
  //   } else {
  //     final ref = FirebaseStorage.instance.ref('${user?.uid}/$title.json');
  //     final builder = await FileManag.readFile(await FileManag.downloadFile(ref));
  //     return builder;
  //   }
  //   return MangaBuilder();
  // }

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
        showSnackBar(e.message);
      }
      return [];
    }
  }
}
