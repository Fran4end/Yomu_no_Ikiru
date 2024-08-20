part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final File? image;

  AuthSignUp({
    required this.email,
    required this.password,
    required this.username,
    required this.image,
  });
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({
    required this.email,
    required this.password,
  });
}

final class AuthCheckCurrentUser extends AuthEvent {}

final class AuthSignOut extends AuthEvent {}
