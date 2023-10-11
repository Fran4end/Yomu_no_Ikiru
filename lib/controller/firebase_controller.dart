import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'utils.dart';

class FirebaseController {
  static User? user = FirebaseAuth.instance.currentUser;

  static Future<void> uploadJson(File file, BuildContext context) async {
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (kDebugMode) {
        Utils.showSnackBar('user not logged or file not valid');
      }
    } else {
      final ex = await file.exists();
      if (ex) {
        String title = basename(file.path);
        final ref = FirebaseStorage.instance.ref();
        try {
          final metadata = await ref.child('${user?.uid}/$title').getMetadata();
          final lastModified = metadata.timeCreated;
          if (lastModified!.isBefore(file.lastModifiedSync())) {
            await ref.child('${user?.uid}/$title').putFile(file);
          }
        } on FirebaseException catch (e) {
          if (kDebugMode) {
            print("Line 40: $e");
          }
          await ref.child('${user?.uid}/$title').putFile(file);
        }
      }
    }
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
