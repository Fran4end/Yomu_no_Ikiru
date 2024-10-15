import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';
import 'package:yomu_no_ikiru/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:yomu_no_ikiru/core/common/entities/user.dart';
import 'package:yomu_no_ikiru/features/auth/data/model/user_model.dart';
import 'package:yomu_no_ikiru/features/auth/domain/repository/auth_repository.dart';

/// Implantation of AuthRepository to manage the user data and authentication
/// [remoteDataSource] is the data source to get the data from the server
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String username,
    required String email,
    required String password,
    required File? image,
  }) async {
    try {
      String avatarUrl = '';
      UserModel user = await remoteDataSource.signUpWithEmailPassword(
        username: username,
        email: email,
        password: password,
      );
      if (image != null) {
        avatarUrl = await remoteDataSource.uploadAvatarImage(
            imageFile: image, user: user);
      }
      user = user.copyWith(avatarUrl: avatarUrl);
      return _getUser(
        () async => await remoteDataSource.updateUser(
          avatarUrl: avatarUrl,
          id: user.id,
        ),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      final user = await fn();

      return right(user);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure("User not logged in"));
      }

      return right(user);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
