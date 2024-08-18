import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yomu_no_ikiru/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:yomu_no_ikiru/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:yomu_no_ikiru/features/auth/domain/repository/auth_repository.dart';
import 'package:yomu_no_ikiru/features/auth/domain/usecases/user_login.dart';
import 'package:yomu_no_ikiru/features/auth/domain/usecases/user_sign_up.dart';
import 'package:yomu_no_ikiru/features/auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: dotenv.env["supabaseUrl"] as String,
    anonKey: dotenv.env["supabaseAnon"] as String,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  // Datasource
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
        // serviceLocator(),
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
    // ..registerFactory(
    //   () => CurrentUser(
    //     serviceLocator(),
    //   ),
    // )
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        // currentUser: serviceLocator(),
        // appUserCubit: serviceLocator(),
      ),
    );
}
