import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:html/dom.dart';
import 'package:yomu_no_ikiru/constants.dart';
import 'package:yomu_no_ikiru/core/common/data/model/chapter_model.dart';
import 'package:yomu_no_ikiru/core/common/data/model/manga_model.dart';

abstract interface class MangaRemoteDataSource {
  Dio get dio => Dio();

  MangaRemoteDataSource() {
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
  }

  Future<List<MangaModel>> getLatestMangaList();
  Future<List<MangaModel>> getPopularMangaList();
  Future<List<MangaModel>> getSearchMangaList(Map<String, dynamic> filters);
  Future<Map<String, List<String>>> getFilterMangaList();
  Future<Document> getMangaPage(String mangaUrl);

  /// return the details of the [Manga].
  ///
  /// The `values` list have the following order:
  /// - **`values[0]`**: The plot of the manga.
  /// - **`values[1]`**: The list of genres.
  List getMangaDetails(Document mangaPage);
  String translateStatus(String status);
  List<ChapterModel> getChapterList(Document mangaPage);
  Future<List<String>> getChapterImagePagesUrl(String chapterUrl);
  DateTime getFormattedDate(String date);
}
