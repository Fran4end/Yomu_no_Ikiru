import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';
import 'package:yomu_no_ikiru/core/common/entities/user.dart';

///Interface for the AuthRepository
///! Do not touch this file
abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String username,
    required String email,
    required String password,
    required File? image,
  });
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();
}
