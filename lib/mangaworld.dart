import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import 'model/chapter.dart';
import 'constants.dart';
import 'model/manga_builder.dart';
import 'controller/utils.dart';

class MangaWorld {
  static final Dio dio = Dio(BaseOptions(baseUrl: baseUrl));
  final cacheOptions = CacheOptions(
    policy: CachePolicy.refresh,
    store: MemCacheStore(),
    hitCacheOnErrorExcept: [401, 403],
    maxStale: const Duration(hours: 6),
    priority: CachePriority.high,
  );

  MangaWorld() {
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
  }

  Future<Document> getHomePageDocument() async {
    Document document;
    try {
      Response res = await dio.get("");
      document = parse(res.data);
      return document;
    } on DioException catch (e) {
      Utils.showSnackBar("Network problem");
      if (kDebugMode) {
        print("riga 34: $e");
      }
      return throw DioException;
    }
  }

  Map<String, List<MangaBuilder>> all(Document document) {
    List<Element> latestElements = document.querySelectorAll('.comics-grid > .entry');
    List<Element> popularElements = document.querySelectorAll('.comics-flex > .entry');

    final latests = _getLatests(latestElements);
    final popular = _getPopular(popularElements);

    return {'latests': latests, 'popular': popular};
  }

  List<MangaBuilder> _getLatests(var elements) {
    List<MangaBuilder> latests = [];
    for (var element in elements) {
      MangaBuilder tmp = MangaBuilder()
        ..titleImageLink = _getTitleImageLink(element)
        ..status = element.querySelector('.content > .status > a')?.text;
      latests.add(tmp);
    }
    return latests;
  }

  List<MangaBuilder> _getPopular(var elements) {
    List<MangaBuilder> popular = [];
    for (var element in elements) {
      var tmp = MangaBuilder()
        ..titleImageLink = _getTitleImageLink(element)
        ..status = 'In corso';
      popular.add(tmp);
    }
    return popular;
  }

  static Future<List<MangaBuilder>> getResults(String keyword, [int page = 1]) async {
    Response res = Response(requestOptions: RequestOptions());
    List<MangaBuilder> results = [];
    try {
      res = await dio.get('/archive',
          queryParameters: {'sort': 'most_read', 'keyword': keyword, "page": page});
    } on DioException catch (e) {
      Utils.showSnackBar("Network problem");
      if (kDebugMode) {
        print("riga 81: $e");
      }
      return results;
    }

    if (res.statusCode == 200) {
      Document document = parse(res.data);
      var mangaList = document.querySelectorAll('.comics-grid > .entry');
      for (var element in mangaList) {
        results.add(
          MangaBuilder()
            ..status = element.querySelector('.content > .status > a')?.text
            ..titleImageLink = _getTitleImageLink(element)
            ..author = element.querySelector('.content > .author > a')?.text
            ..artist = element.querySelector('.content > .artist > a')?.text
            ..genres = _getGenres(element.querySelectorAll('.content > .genres > a')),
        );
      }
    } else {
      Utils.showSnackBar("Network problem");
    }
    return results;
  }

  static List<String?> _getTitleImageLink(var element) {
    return [
      element.querySelector('.name > .manga-title').text,
      element.querySelector('.thumb > img').attributes['src'],
      element.querySelector('.thumb').attributes['href']
    ];
  }

  Future<Document?> getPageDocument(String link) async {
    Response res = Response(requestOptions: RequestOptions());
    Document? document;
    try {
      res = await dio.get(link.toString());
      document = parse(res.data);
    } on DioException catch (e) {
      Utils.showSnackBar("Network problem");
      if (kDebugMode) {
        print(e);
      }
    }
    return document;
  }

  String getPlot(Document document) {
    return document.querySelector('#noidungm')!.text;
  }

  double? getReadings(Document document) {
    String? readings = document.querySelector('.info > .meta-data')?.children[6].children[1].text;
    return double.tryParse(readings.toString());
  }

  MangaBuilder getAppBarInfo(MangaBuilder builder, Document? document) {
    if (document == null) {
      return builder;
    }
    var info = document.querySelector('.info > .meta-data');
    if (builder.artist == "No artist found") {
      builder
        ..artist = null
        ..author = null;
    }
    builder
      ..artist ??= info!.children[3].querySelector('a')!.text
      ..author ??= info!.children[2].querySelector('a')!.text
      ..genres = _getGenres(info?.children[1].querySelectorAll('a'));
    return builder;
  }

  static List<String> _getGenres(var elements) {
    List<String> tmp = [];
    for (var element in elements) {
      tmp.add(element.text);
    }
    return tmp;
  }

  Future<double> getVote(Document document) async {
    final element = document.querySelector('.info > .references');
    if (element == null) {
      return 0;
    }
    String att = '';
    for (var element in element.children) {
      if (element.firstChild != null) {
        var tmp = element.firstChild!.attributes;
        if (tmp['href'].toString().contains('myanimelist')) {
          att = tmp['href'].toString();
        }
      }
    }
    if (att == '') {
      return 0;
    }
    try {
      final res = await dio.get(att);
      var page = parse(res.data);
      var ret = page.getElementsByClassName('score-label')[0].text;
      if (ret == 'N/A') {
        return 0;
      } else {
        return double.parse(ret);
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print("error: $e");
      }
      return -1;
    } on FormatException {
      return 0;
    }
  }

  List<Chapter> getChapters(Document document) {
    List<Chapter> chapters = [];
    List<Element> chaptersElement =
        document.querySelector('.chapters-wrapper')!.querySelectorAll('.chapter > .chap');
    for (var chap in chaptersElement) {
      Map attributes = chap.attributes;
      String link = attributes['href'];
      int tmp = link.indexOf('?');
      if (tmp > -1) {
        link = '${link.substring(0, tmp)}?style=list';
      } else {
        link = '$link?style=list';
      }
      List<String> data = [
        attributes['title'],
        chap.querySelector('i')!.text,
        link,
      ];
      chapters
          .add(Chapter(date: data[1], title: data[0].replaceAll("Scan ITA", ""), link: data[2]));
    }
    return chapters;
  }
}
