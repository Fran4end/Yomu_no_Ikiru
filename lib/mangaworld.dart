import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:manga_app/constants.dart';
import 'package:manga_app/model/manga_builder.dart';
import 'package:manga_app/model/utils.dart';

class MangaWorld {
  static final Dio dio = Dio(BaseOptions(baseUrl: baseUrl));
  final cacheOptions = CacheOptions(
    store: MemCacheStore(),
    hitCacheOnErrorExcept: [401, 403],
    maxStale: const Duration(hours: 12),
  );
  final retryOptions = RetryInterceptor(
    dio: dio,
    logPrint: print,
    retries: 2,
    retryDelays: const [
      Duration(seconds: 10),
      Duration(seconds: 10),
    ],
  );

  MangaWorld() {
    dio.interceptors
      ..add(retryOptions)
      ..add(DioCacheInterceptor(options: cacheOptions));
  }

  Future<Document?> getHomePageDocument() async {
    Document? document;
    try {
      Response res = await dio.get("");
      document = parse(res.data);
    } on DioError catch (e) {
      Utils.showSnackBar("Network problem");
      if (kDebugMode) {
        print("riga 34: $e");
      }
    }
    return document;
  }

  Future<Map<String, List<MangaBuilder>>> all(Document document) async {
    List<Element> latestElements = document.querySelectorAll('.comics-grid > .entry');
    List<Element> popularElements = document.querySelectorAll('.comics-flex > .entry');

    final latests = await _getLatests(latestElements);
    final popular = await _getPopular(popularElements);

    return {'latests': latests, 'popular': popular};
  }

  Future<List<MangaBuilder>> _getLatests(var elements) async {
    List<MangaBuilder> latests = [];
    for (var element in elements) {
      MangaBuilder tmp = MangaBuilder()
        ..titleImageLink = _getTitleImageLink(element)
        ..status = element.querySelector('.content > .status > a')?.text;
      latests.add(tmp);
    }
    return latests;
  }

  Future<List<MangaBuilder>> _getPopular(var elements) async {
    List<MangaBuilder> popular = [];
    for (var element in elements) {
      var tmp = MangaBuilder()
        ..titleImageLink = _getTitleImageLink(element)
        ..status = 'In corso';
      popular.add(tmp);
    }
    return popular;
  }

  static Future<List<MangaBuilder>> getResults(String keyword,
      [List<MangaBuilder> results = const []]) async {
    Response res = Response(requestOptions: RequestOptions());
    try {
      res = await dio.get('/archive', queryParameters: {'sort': 'most_read', 'keyword': keyword});
    } on DioError catch (e) {
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
            ..plot = element.querySelector('.content > .story')?.text
            ..author = element.querySelector('.content > .author > a')?.text
            ..artist = element.querySelector('.content > .artist > a')?.text
            ..genres = _getGenres(element.querySelectorAll('.content > .genres > a'))!,
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

  Future<MangaBuilder> getAllInfo(MangaBuilder builder) async {
    final saveBuilder = await Utils.isOnLibrary(builder.title);
    try {
      if (saveBuilder.runtimeType == MangaBuilder) {
        builder = saveBuilder;
        builder.save = true;
      }
      Document? document = await _getDetailedPageDocument(builder);
      if (document == null) {
        return builder;
      }
      var info = document.querySelector('.info > .meta-data');
      String? readings = info?.children[6].children[1].text;
      builder
        ..readingsVote = [
          double.tryParse(readings.toString()),
          double.tryParse(await _getVote(document.querySelector('.info > .references')))
        ]
        ..artist ??= info!.children[3].querySelector('a')!.text
        ..author ??= info!.children[2].querySelector('a')!.text
        ..genres = _getGenres(info?.children[1].querySelectorAll('a'))!
        ..plot ??= document.querySelector('.comic-description > #noidungm')!.text;
      if (builder.chapters.isEmpty) {
        builder = await getChapters(builder, document);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return builder;
  }

  Future<MangaBuilder> getChapters(MangaBuilder builder, Document document) async {
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
      // String copertina = await _getCopertina(link);
      List<String> data = [
        attributes['title'],
        chap.querySelector('i')!.text,
        link,
      ];
      builder.chap = data;
    }
    return builder;
  }

  Future<Document?> _getDetailedPageDocument(MangaBuilder builder) async {
    final link = builder.link;
    Response res = Response(requestOptions: RequestOptions());
    Document? document;
    try {
      res = await dio.get(link.toString());
      document = parse(res.data);
    } on DioError catch (e) {
      Utils.showSnackBar("Network problem");
      if (kDebugMode) {
        print(e);
      }
    }
    return document;
  }

  static List<String>? _getGenres(var elements) {
    List<String>? tmp = [];
    for (var element in elements) {
      tmp.add(element.text);
    }
    return tmp;
  }

  _getVote(var element) async {
    if (element == null) {
      return '0';
    }
    String att = '';
    element.children.forEach((element) {
      if (element.firstChild != null) {
        var tmp = element.firstChild.attributes;
        if (tmp['href'].toString().contains('myanimelist')) {
          att = tmp['href'].toString();
        }
      }
    });
    if (att == '') {
      return '0';
    }
    final res = await dio.get(att);
    if (res.statusCode == 200) {
      var page = parse(res.data);
      var ret = page.getElementsByClassName('score-label')[0].text;
      if (ret == 'N/A') {
        return '0';
      } else {
        return ret;
      }
    } else {
      if (kDebugMode) {
        print(throw Exception);
      }
    }
  }
}
