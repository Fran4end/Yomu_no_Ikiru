import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';
import 'package:yomu_no_ikiru/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:yomu_no_ikiru/features/auth/domain/entities/user.dart';
import 'package:yomu_no_ikiru/features/auth/domain/repository/auth_repository.dart';

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
    required String avatarUrl,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
        username: username,
        email: email,
        password: password,
        avatarUrl: avatarUrl,
      ),
    );
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
}
