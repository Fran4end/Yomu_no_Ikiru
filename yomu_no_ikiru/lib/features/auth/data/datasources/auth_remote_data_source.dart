import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yomu_no_ikiru/core/error/exceptions.dart';
import 'package:yomu_no_ikiru/features/auth/data/model/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailPassword({
    required String email,
    required String password,
    required String username,
    required String avatarUrl,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<String> uploadAvatarImage({
    required File imageFile,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final res = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (res.user == null) {
        throw const ServerException("User is null");
      }
      return UserModel.fromJson(res.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String email,
    required String password,
    required String username,
    required String avatarUrl,
  }) async {
    try {
      final res = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          "username": username,
          "avatar_url": avatarUrl,
        },
      );
      if (res.user == null) {
        throw const ServerException("User is null");
      }
      return UserModel.fromJson(res.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadAvatarImage({
    required File imageFile,
  }) async {
    // TODO: implement uploadAvatarImage
    throw UnimplementedError();
    /*try {
      final pref = await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(),
      );
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = 'avatar/$fileName';
      pref.setString(filePath, base64Image);
      return filePath;
      // await supabaseClient.storage.from('avatars').uploadBinary(
      //       filePath,
      //       bytes,
      //       fileOptions: FileOptions(contentType: imageFile.mimeType),
      //     );
      // return await supabaseClient.storage
      //     .from('avatars')
      //     .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
    } catch (e) {
      throw ServerException(e.toString());
    }*/
  }
}
