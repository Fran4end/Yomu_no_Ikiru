import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:html/dom.dart';
import 'package:yomu_no_ikiru/core/utils/constants.dart';
import 'package:yomu_no_ikiru/core/common/data/model/chapter_model.dart';
import 'package:yomu_no_ikiru/core/common/data/model/manga_model.dart';

abstract interface class MangaRemoteDataSource {
  /// The Dio instance used to make the requests.
  Dio get dio => Dio();

  /// The CookieJar instance used to store the cookies.
  CookieJar get cookieJar => CookieJar();

  MangaRemoteDataSource() {
    dio
      ..interceptors.add(DioCacheInterceptor(options: cacheOptions))
      ..interceptors.add(CookieManager(cookieJar))
      ..options.followRedirects = false
      ..options.validateStatus = (status) => status != null && status >= 200 && status < 400;
  }

  /// Retrieve the newest manga list of site.
  ///
  /// Return a list of [MangaModel].
  ///
  /// - Throws a `ServerException` if the site not return a correct page.
  /// - Throws a `NoInternetException` if there is no internet connection.
  Future<List<MangaModel>> getLatestMangaList();

  /// Retrieve the most popular manga list of site.
  ///
  /// Return a list of [MangaModel].
  ///
  /// - Throws a `ServerException` if the site not return a correct page.
  /// - Throws a `NoInternetException` if there is no internet connection.
  Future<List<MangaModel>> getPopularMangaList();

  /// Retrieve the manga list of site filtered by the [filters].
  ///
  /// It is recommended that sort filter is set by default on most_read or popular.
  ///
  /// Return a list of `MangaModel` by passing the [filters].
  ///
  /// - Throws a `ServerException` if the site not return a correct page.
  /// - Throws a `NoInternetException` if there is no internet connection.
  Future<List<MangaModel>> getSearchMangaList(Map<String, dynamic> filters);

  /// Retrieve the manga list of site filters.
  ///
  /// Return a map with the possible filters.
  ///
  /// - Throws a `ServerException` if the site not return a correct page.
  /// - Throws a `NoInternetException` if there is no internet connection.
  Future<Map<String, List<String>>> getFilterMangaList();

  /// Retrieve the manga page.
  ///
  /// Return a `Document` with the manga page loaded by passing the [mangaUrl].
  Future<Document> getMangaPage(String mangaUrl);

  /// Get the details of the [Manga].
  ///
  /// return the details of the `Manga` that can be retrieved only on [mangaPage].
  ///
  /// The `values` list have the following order:
  /// - **`values[0]`**: The plot of the manga.
  /// - **`values[1]`**: The list of genres.
  List getMangaDetails(Document mangaPage);

  /// Translate the status of the `Manga` to the app language.
  ///
  /// return the translated status of the `Manga`.
  String translateStatus(String status);

  /// Get the list of chapters of the `Manga`.
  ///
  /// Return a list of [ChapterModel] by passing the [mangaPage] already loaded.
  List<ChapterModel> getChapterList(Document mangaPage);

  /// Get the `Chapter` pages.
  ///
  /// Return the list of pages as a list of `String` URLs by passing the [chapterUrl].
  Future<List<String>> getChapterImagePagesUrl(String chapterUrl);

  /// Get the formatted date.
  ///
  /// Return the formatted date as a `DateTime` by passing the [date]
  ///
  /// Must be implemented with format dd/mm/yy.
  DateTime getFormattedDate(String date);
}
