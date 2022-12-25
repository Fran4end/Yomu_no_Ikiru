import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:manga_app/costants.dart';
import 'package:manga_app/manga.dart';
import 'package:manga_app/manga_builder.dart';

class MangaWorld {
  List<MangaBuilder> latests = [];
  List<MangaBuilder> populars = [];

  Future<Document> getHomePageDocument() async {
    http.Response res = await http.get(Uri.parse(baseUrl));
    Document document = parse(res.body);

    return document;
  }

  Future<Map<String, List<MangaBuilder>>> all(Document document) async {
    List<Element> latestElemets = document.querySelectorAll('.comics-grid > .entry');
    List<Element> popularElemets = document.querySelectorAll('.comics-flex > .entry');

    latests = await _getLatests(latestElemets);
    populars = await _getPopulars(popularElemets);

    return {'latests': latests, 'populars': populars};
  }

  Future<List<MangaBuilder>> onlyLatests(Document document) async {
    var latestElemets = document.querySelectorAll('.comics-grid > .entry');
    List<MangaBuilder> latestes = await _getLatests(latestElemets);
    return latestes;
  }

  Future<List<MangaBuilder>> _getLatests(var elements) async {
    List<MangaBuilder> latests = [];
    for (var element in elements) {
      MangaBuilder tmp = MangaBuilder()
        ..titleImageLink = _getTitleImageLink(element)
        ..status = element.querySelector('.content > .status > a')?.text;
      latests.add(tmp);
      mangasBuilder.update(
        tmp.title.toString(),
        (value) => tmp,
        ifAbsent: () => tmp,
      );
    }
    return latests;
  }

  Future<List<MangaBuilder>> _getPopulars(var elements) async {
    List<MangaBuilder> populars = [];
    for (var element in elements) {
      var tmp = MangaBuilder()
        ..titleImageLink = _getTitleImageLink(element)
        ..status = 'In corso';
      populars.add(tmp);
    }
    return populars;
  }

  Future<List<String?>> buildSuggestions(String keyworld) async {
    List<String?> sugg = [];
    http.Response res =
        await http.Client().get(Uri.parse('$baseUrl/archive?sort=most_read&keyword=$keyworld'));
    if (res.statusCode == 200) {
      Document document = parse(res.body);
      var titleList = document.querySelectorAll('.comics-grid > .entry');
      for (var element in titleList) {
        String? title = element.querySelector('.content > .name > .manga-title')?.text;
        sugg.add(title);
      }
    } else {
      if (kDebugMode) {
        print(throw Exception);
      }
    }
    return sugg;
  }

  Future<List<Manga>> getResults(String keyworld) async {
    List<Manga> tmp = [];
    http.Response res =
        await http.Client().get(Uri.parse('$baseUrl/archive?sort=most_read&keyword=$keyworld'));
    if (res.statusCode == 200) {
      Document document = parse(res.body);
      var mangaList = document.querySelectorAll('.comics-grid > .entry');
      for (var element in mangaList) {
        MangaBuilder builder = MangaBuilder()
          ..status = element.querySelector('.content > .status > a')?.text
          ..titleImageLink = _getTitleImageLink(element)
          ..trama = element.querySelector('.content > .story')?.text
          ..author = element.querySelector('.content > .author > a')?.text
          ..artist = element.querySelector('.content > .artist > a')?.text
          ..genres = _getGenres(element.querySelectorAll('.content > .genres > a'))!;
        tmp.add(Manga(builder: builder));
        mangasBuilder.update(
          builder.title.toString(),
          (value) => builder,
          ifAbsent: () => builder,
        );
      }
    } else {
      if (kDebugMode) {
        print(throw Exception);
      }
    }
    return tmp;
  }

  List<String?> _getTitleImageLink(var element) {
    return [
      element.querySelector('.content > .name > .manga-title').text,
      element.querySelector('.thumb > img').attributes['src'],
      element.querySelector('.thumb').attributes['href']
    ];
  }

  Future<MangaBuilder> getAllInfo(MangaBuilder builder) async {
    bool timeout = false;
    do {
      try {
        Document document = await _getDetailedPageDocument(builder);
        var info = document.querySelector('.info > .meta-data');
        var readings = info?.children[6].children[1].text;
        builder
          ..readingsVote = [
            double.tryParse(readings.toString()),
            double.tryParse(await _getVote(document.querySelector('.info > .references')))
          ]
          ..artist ??= info!.children[3].querySelector('a')!.text
          ..author ??= info!.children[2].querySelector('a')!.text
          ..genres = _getGenres(info?.children[1].querySelectorAll('a'))!
          ..trama ??= document.querySelector('.comic-description > #noidungm')!.text;
        builder = await getChapters(builder);
        timeout = false;
      } catch (e, s) {
        if (e.toString().contains('Connection reset by peer')) {
          timeout = true;
        }
        if (kDebugMode) {
          print('$e \n $s');
        }
      }
    } while (timeout);
    return builder;
  }

  Future<MangaBuilder> getChapters(MangaBuilder builder) async {
    Document document = await _getDetailedPageDocument(builder);
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

  Future<Document> _getDetailedPageDocument(MangaBuilder builder) async {
    final link = builder.link;
    final res = await http.Client().get(Uri.parse(link.toString()));
    Document document = parse(res.body);
    return document;
  }

  Future<String> _getCopertina(String? link) async {
    if (link == null) {
      return 'null';
    }
    http.Response res = await http.get(Uri.parse(link));
    Document document = parse(res.body);
    String image = document.querySelector('#page > #page-0')!.attributes["src"]!;
    return image;
  }

  List<String>? _getGenres(var elements) {
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
    final res = await http.Client().get(Uri.parse(att));
    if (res.statusCode == 200) {
      var page = parse(res.body);
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
