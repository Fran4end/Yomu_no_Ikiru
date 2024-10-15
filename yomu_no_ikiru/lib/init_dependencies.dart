import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yomu_no_ikiru/core/common/cubits/appuser/app_user_cubit.dart';
import 'package:yomu_no_ikiru/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:yomu_no_ikiru/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:yomu_no_ikiru/features/auth/domain/repository/auth_repository.dart';
import 'package:yomu_no_ikiru/features/auth/domain/usecases/current_user.dart';
import 'package:yomu_no_ikiru/features/auth/domain/usecases/user_login.dart';
import 'package:yomu_no_ikiru/features/auth/domain/usecases/user_sign_up.dart';
import 'package:yomu_no_ikiru/features/auth/presentation/bloc/auth_bloc.dart';

/// Initializes the service locator and sets up all necessary dependencies.
///
/// This function is responsible for configuring the service locator instance
/// using the `GetIt` package. It registers all the required services and
/// dependencies that will be used throughout the application.
///
/// Usage:
/// ```dart
/// await initDependencies();
/// ```
///
/// Make sure to call this function at the start of your application to ensure
/// that all dependencies are properly set up before they are used.
final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: dotenv.env["supabaseUrl"] as String,
    anonKey: dotenv.env["supabaseAnon"] as String,
  );

  //database initialization
  serviceLocator.registerLazySingleton(() => supabase.client);

  //user retrive from session
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  // DataSource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}
