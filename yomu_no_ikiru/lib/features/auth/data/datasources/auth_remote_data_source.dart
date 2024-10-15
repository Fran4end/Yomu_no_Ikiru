import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yomu_no_ikiru/core/error/exceptions.dart';
import 'package:yomu_no_ikiru/features/auth/data/model/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel> signUpWithEmailPassword({
    required String email,
    required String password,
    required String username,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();

/**
 *  TODO: Implement Google Sign In
 *  Future<UserModel> loginWithGoogle();
 */

/// this method will upload user's avatar image to storage and return the url
  Future<String> uploadAvatarImage({
    required File imageFile,
    required UserModel user,
  });

///  this method will update user's avatar url in profiles table and auth table
  Future<UserModel> updateUser({
    required String avatarUrl,
    required String id,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

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
      return UserModel.fromJson(res.user!.toJson()).copyWith(
        email: email,
      );
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
  }) async {
    try {
      final res = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          "username": username,
          "avatar_url": '',
        },
      );
      if (res.user == null) {
        throw const ServerException("User is null");
      }
      return UserModel.fromJson(res.user!.toJson()).copyWith(
        email: email,
      );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession == null) {
        return null;
      }

      final userData = await supabaseClient.from('profiles').select().eq(
            'id',
            currentUserSession!.user.id,
          );
      return UserModel.fromJson(userData.first).copyWith(
        email: currentUserSession!.user.email,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadAvatarImage({
    required File imageFile,
    required UserModel user,
  }) async {
    try {
      final fileName = user.id;
      final filePath = fileName;
      await supabaseClient.storage.from('avatars').upload(
            filePath,
            imageFile,
          );
      return await supabaseClient.storage.from('avatars').getPublicUrl(filePath);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> updateUser({
    required String avatarUrl,
    required String id,
  }) async {
    try {
      await supabaseClient.from('profiles').update(
        {
          'avatar_url': avatarUrl,
        },
      ).eq('id', id);

      final res = await supabaseClient.auth.updateUser(
        UserAttributes(
          data: {
            'avatar_url': avatarUrl,
          },
        ),
      );
      if (res.user == null) {
        throw const ServerException("User not update successful");
      }
      return UserModel.fromJson(res.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
