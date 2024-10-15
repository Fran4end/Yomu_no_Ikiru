import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';

///**interface for all use case**
///
///[SuccessType] is the type of the success response
///
///[Params] is the type of the parameter required for the use case (to implement as class or primitive type)
///
/// Example:
/// ```dart
/// class UserLogin implements UseCase<User, UserLoginParams> {
///  final AuthRepository authRepository;
///  UserLogin(this.authRepository);
///  @override
/// Future<Either<Failure, User>> call(UserLoginParams params) async {
///   return await authRepository.loginWithEmailPassword(
///   email: params.email,
///   password: params.password,
///  );
/// }
/// }
/// class UserLoginParams {
/// final String email;
/// final String password;
///   UserLoginParams({
///     required this.email,
///     required this.password,
///   });
/// }
/// ```
///
///! No need to change this class, just implement it and the call method
abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
