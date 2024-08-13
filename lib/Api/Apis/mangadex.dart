import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';

import '../../constants.dart';
import '../../controller/utils.dart';
import '../../model/chapter.dart';
import '../../model/manga_builder.dart';

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

  Future<List<MangaBuilder>> getResult(String keyword, int page, [int pageSize = 16]) async {
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
    try {
      final coverRes = await dio.get("/cover/$coverID");
      final coverFileName = coverRes.data["data"]["attributes"]["fileName"];
      return [
        title ?? element["attributes"]["title"]["ja"],
        "https://uploads.mangadex.org/covers/$mangaID/$coverFileName",
        "https://api.mangadex.org/manga/$mangaID",
      ];
    } on DioException catch (e) {
      Utils.showSnackBar("Network problem");
      if (kDebugMode) {
        print(e.requestOptions.uri);
        print("MangaDex riga 48: $e");
      }
      return [
        title ?? element["attributes"]["title"]["ja"],
        null,
        "https://api.mangadex.org/manga/$mangaID",
      ];
    }
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
    int offset = 0;
    int limit = 100;
    do {
      try {
        final res = await dio.get("/manga/$id/feed", queryParameters: {
          "translatedLanguage[]": "en",
          "limit": limit,
          "offset": offset,
        });
        if (res.statusCode == 429 || res.statusCode == 403) {
          break;
        }
        final List chaps = res.data["data"].where((e) => e["type"] == "chapter").toList();
        for (var chap in chaps) {
          if (chap["attributes"]["chapter"] != null) {
            String? title =
                chap["attributes"]["chapter"] + " " + (chap["attributes"]["title"] ?? "");
            if (title == null || title == "") {
              title = 'chapter ${chap["attributes"]["chapter"]}';
            }
            final DateTime date = DateTime.parse(chap["attributes"]["publishAt"]);
            chapters.add(
              Chapter(
                  id: chap["id"],
                  date: date,
                  title: title,
                  link: 'https://api.mangadex.org/at-home/server/${chap["id"]}',
                  volume: chap["volume"],
                  order: double.parse(chap["attributes"]["chapter"])),
            );
          }
        }
        final data = res.data["data"].length;
        if (data < limit) {
          break;
        } else {
          offset += limit;
        }
      } on DioException catch (e) {
        Utils.showSnackBar("Network problem");
        if (kDebugMode) {
          print(e.requestOptions.uri);
          print("MangaDex riga 48: $e");
        }
        break;
      }
    } while (true);
    chapters.sort((a, b) => a.order!.compareTo(b.order!));
    return chapters.reversed.toList();
  }
}
