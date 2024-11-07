part of 'init_dependencies.dart';

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
  _initManga();

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

_initManga() {
  serviceLocator
    // Repository
    ..registerFactory<MangaRepositoryImpl>(
      () => MangaRepositoryImpl(),
    )
    ..registerFactory<MangaRepository>(
      () => MangaRepositoryImpl(),
    )
    // Usecases
    ..registerFactory(
      () => SearchMangaList(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetMangaDetails(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetChapter(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => MangaBloc(
        getMangaDetails: serviceLocator(),
        getMangaList: serviceLocator(),
      ),
    )
    ..registerFactory<ReaderBloc>(
      () => ReaderBloc(
        getCurrentChapter: serviceLocator(),
      ),
    );
}
