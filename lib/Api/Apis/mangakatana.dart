import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import '../../constants.dart';
import '../../controller/utils.dart';
import '../../model/chapter.dart';
import '../../model/manga_builder.dart';

class MangaKatana {
  static final Dio dio = Dio(BaseOptions(baseUrl: "https://mangakatana.com/"));

  MangaKatana() {
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
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

  Future<List<MangaBuilder>> getResults(String keyword, int page) async {
    Response res = Response(requestOptions: RequestOptions());
    List<MangaBuilder> results = [];
    try {
      if (keyword == "") {
        res = await dio.get('manga/page/$page');
      } else {
        res = await dio.get('/page/$page/', queryParameters: {'search': keyword});
      }
    } on DioException catch (e) {
      Utils.showSnackBar("Network problem");
      if (kDebugMode) {
        print("MangaKatana riga 41: $e");
        print(e.requestOptions.uri);
      }
      return results;
    }
    if (res.statusCode == 200) {
      Document document = parse(res.data);
      var mangaList = document.querySelectorAll('div#book_list > div.item');
      for (var element in mangaList) {
        results.add(
          MangaBuilder()
            ..status = element.querySelector('.status')?.text
            ..titleImageLink = _getTitleImageLink(element)
            ..genres = _getGenres(element.querySelectorAll("div.text > div.genres > a")),
        );
      }
    } else {
      Utils.showSnackBar("Network problem");
    }
    return results;
  }

  List<String?> _getTitleImageLink(var element) {
    final linkTitle = element.querySelector("div.text > h3.title > a");
    return [
      linkTitle?.text,
      element.querySelector('div.media > div > a > img').attributes['src'],
      linkTitle.attributes['href'],
    ];
  }

  String _getPlot(Document document) {
    final innerHtml = document.querySelector('div.summary > p')!.innerHtml;
    return innerHtml.replaceAll("<br>", "\n");
  }

  MangaBuilder getAppBarInfo(MangaBuilder builder, Document? document) {
    if (document == null) {
      return builder;
    }
    var info = document.querySelector('.info > .meta');
    final artistAuthor = info?.children[1].querySelector(".authors")?.querySelectorAll("a");
    if (builder.author == "No author found") {
      builder
        ..artist = null
        ..author = null;
    }
    builder.appBarInfo = [
      null,
      artistAuthor?.last.text,
      artistAuthor?.first.text,
      _getGenres(info?.children[2].querySelectorAll('a')),
      _getPlot(document),
    ];

    return builder;
  }

  List<String> _getGenres(var elements) {
    List<String> tmp = [];
    for (var element in elements) {
      tmp.add(element.text);
    }
    return tmp;
  }

  List<Chapter> getChapters(Document? document) {
    if (document == null) {
      return [];
    }
    List<Chapter> chapters = [];
    List<Element> chaptersElement =
        document.querySelector('div.chapters')!.querySelectorAll('div.chapter > a');
    for (var chap in chaptersElement) {
      List<String> data = [
        chap.text,
        chap.parent!.parent!.parent!.children[1].text,
        chap.attributes['href']!,
      ];
      chapters
          .add(Chapter(id: "MangaKatana_${data[0]}", date: data[1], title: data[0], link: data[2]));
    }
    return chapters;
  }
}
