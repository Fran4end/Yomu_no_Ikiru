import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';
import 'package:yomu_no_ikiru/core/usecase/usecase.dart';
import 'package:yomu_no_ikiru/features/auth/domain/entities/user.dart';
import 'package:yomu_no_ikiru/features/auth/domain/repository/auth_repository.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;

  const UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      username: params.username,
      email: params.email,
      password: params.password,
      avatarUrl: params.avatarUrl,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String username;
  final String avatarUrl;

  UserSignUpParams({
    required this.email,
    required this.password,
    required this.username,
    required this.avatarUrl,
  });
}
