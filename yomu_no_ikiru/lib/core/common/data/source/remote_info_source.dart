import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:html/dom.dart';
import 'package:yomu_no_ikiru/constants.dart';
import 'package:yomu_no_ikiru/core/common/data/model/manga_info_model.dart';

abstract interface class MangaRemoteInfoSource {
  Dio get dio => Dio();
  //The page of the manga on listing service (MAL, AniList, ...)to get the information from
  Document get mangaPage;

  MangaRemoteInfoSource() {
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
  }

  Future<Document> getMangaPage(String mangaTitle);
  double getRanking(MangaInfoModel manga, Document mangaPage);
  String getUser(MangaInfoModel manga, Document mangaPage);
  String getMembers(MangaInfoModel manga, Document mangaPage);
  String getPopularity(MangaInfoModel manga, Document mangaPage);
  String getScore(MangaInfoModel manga, Document mangaPage);
}
