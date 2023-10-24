import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:yomu_no_ikiru/model/chapter.dart';
import 'package:yomu_no_ikiru/model/manga_builder.dart';

import '../../constants.dart';
import '../../controller/utils.dart';

class MangaDex {
  static final Dio dio = Dio(BaseOptions(baseUrl: "https://api.mangadex.org"));

  MangaDex() {
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
  }

  Future<Map> getJson(String link) async {
    try {
      final res = await dio.get(link);
      if (res.statusCode == 200) {
        return res.data;
      } else {
        if (kDebugMode) {
          print(res.statusCode);
        }
        Utils.showSnackBar("Network problem ${res.statusCode}");
        return {};
      }
    } on DioException catch (e) {
      Utils.showSnackBar("Network problem");
      if (kDebugMode) {
        print(e.requestOptions.uri);
        print("MangaDex riga 48: $e");
      }
      return {};
    }
  }

  Future<List<MangaBuilder>> getResult(String keyword, int page) async {
    Response res = Response(requestOptions: RequestOptions());
    page--;
    try {
      int offset = pageSize * page;
      res = await dio.get('/manga', queryParameters: {
        'order[rating]': 'desc',
        'title': keyword,
        "offset": offset,
        "limit": pageSize
      });
      if (res.statusCode == 200) {
        List<MangaBuilder> builders = [];
        for (Map mangaJson in res.data["data"]) {
          final id = mangaJson["id"];
          final attributes = mangaJson["attributes"];
          final titleImageLink = await _getTitleImageLink(mangaJson, id);
          final genres = attributes["tags"]
              .where((element) => element["attributes"]["group"] == "genre")
              .map<String>((e) => e["attributes"]["name"]["en"].toString())
              .toList();
          final builder = MangaBuilder()
            ..id = id
            ..status = attributes["status"]
            ..plot = attributes["description"]["en"].toString().trim()
            ..genres = genres ?? []
            ..titleImageLink = titleImageLink;
          builders.add(builder);
        }
        return builders;
      } else {
        if (kDebugMode) {
          print(res.statusCode);
        }
        Utils.showSnackBar("Network problem ${res.statusCode}");
        return [];
      }
    } on DioException catch (e) {
      Utils.showSnackBar("Network problem");
      if (kDebugMode) {
        print(e.requestOptions.uri);
        print("MangaDex riga 48: $e");
      }
      return [];
    }
  }

  static Future<List<String?>> _getTitleImageLink(var element, String mangaID) async {
    final title = element["attributes"]["title"]["en"];
    final coverID =
        element["relationships"].where((element) => element["type"] == "cover_art").first["id"];
    final coverRes = await dio.get("/cover/$coverID");
    final coverFileName = coverRes.data["data"]["attributes"]["fileName"];
    return [
      title ?? element["attributes"]["title"]["ja"],
      "https://uploads.mangadex.org/covers/$mangaID/$coverFileName",
      "https://api.mangadex.org/manga/$mangaID",
    ];
  }

  Future<MangaBuilder> getUnloadInfo(MangaBuilder builder) async {
    Map json = (await dio.get(builder.link)).data;
    json = json["data"];
    final String authorID =
        json["relationships"].where((element) => element["type"] == "author").first["id"];
    final String artistID =
        json["relationships"].where((element) => element["type"] == "artist").first["id"];

    List res = await Future.wait([dio.get("/author/$authorID"), dio.get("/author/$artistID")]);
    builder
      ..author = res[0].data["data"]["attributes"]["name"]
      ..artist = res[1].data["data"]["attributes"]["name"];
    return builder;
  }

  Future<List<Chapter>> getChapters(String id) async {
    List<Chapter> chapters = [];
    bool allLoaded = true;
    int offset = 0;
    int limit = 100;
    do {
      final res = await dio.get("/manga/$id/feed", queryParameters: {
        "translatedLanguage[]": "en",
        "limit": limit,
        "offset": offset,
      });
      for (var chap in res.data["data"].where((e) => e["type"] == "chapter")) {
        String? title = chap["attributes"]["chapter"] + " " + chap["attributes"]["title"];
        if (title == null || title == "") {
          title = 'chapter ${chap["attributes"]["chapter"]}';
        }
        final DateTime date = DateTime.parse(chap["attributes"]["publishAt"]);
        chapters.add(
          Chapter(
              id: chap["id"],
              date: DateFormat('d MMMM y').format(date.toLocal()),
              title: title,
              link: 'https://api.mangadex.org/at-home/server/${chap["id"]}',
              volume: chap["volume"],
              order: double.parse(chap["attributes"]["chapter"])),
        );
      }
      if (res.data["total"] > chapters.length) {
        offset += limit;
      } else {
        allLoaded = false;
      }
    } while (allLoaded);
    chapters.sort((a, b) => a.order!.compareTo(b.order!));
    return chapters.reversed.toList();
  }

  getChapterImages(List<Chapter> chapters) async {
    for (var chapter in chapters) {
      final data = await dio.get(chapter.link!);
      print(data);
    }
  }
}
