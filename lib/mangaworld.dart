import 'dart:io';

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
          ..genres = _getGenres(element.querySelectorAll('.content > .genres > a'));
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

  Stream<MangaBuilder> getAllInfo(MangaBuilder builder) async* {
    bool timeout = false;
    do {
      try {
        final link = builder.link;
        final res = await http.Client().get(Uri.parse(link.toString()));
        if (res.statusCode == 200) {
          Document document = parse(res.body);
          var info = document.querySelector('.info > .meta-data');
          var readings = info?.children[6].children[1].text;
          builder
            ..readingsVote = [
              double.tryParse(readings.toString()),
              double.tryParse(await _getVote(document.querySelector('.info > .references')))
            ]
            ..artist ??= info?.children[3].querySelector('a')?.text
            ..author ??= info?.children[2].querySelector('a')?.text
            ..genres ??= _getGenres(info?.children[1].querySelectorAll('a'))
            ..trama ??= document.querySelector('.comic-description > #noidungm')?.text;
          await for (var chapter
              in _getChapterVolume(document.querySelector('.chapters-wrapper'))) {
            builder.chap = chapter;
            yield builder;
          }
        } else {
          if (kDebugMode) {
            print(throw Exception);
          }
        }
        timeout = false;
        yield builder;
      } catch (e) {
        if (e.toString().contains('Connection reset by peer')) {
          timeout = true;
        }
        print('mangaworld 149: $e');
      }
    } while (timeout);
  }

  Stream<List<String>> _getChapterVolume(var element) async* {
    List<Element> volumes = element.querySelectorAll('.volume-element');
    List<Element> chaps = [];
    String volume = '';
    if (volumes.isNotEmpty) {
      for (var element in volumes) {
        volume = element.querySelector('.volume > .volume-name')!.text;
        chaps = element.querySelectorAll('.volume-chapters > .chapter');
        await for (var chap in _getChapters(chaps, volume)) {
          yield chap;
        }
      }
    } else {
      chaps = element.querySelectorAll('.chapters-wrapper > .chapter');
      await for (var chap in _getChapters(chaps)) {
        yield chap;
      }
    }
  }

  Stream<List<String>> _getChapters(List<Element> chaps, [String volume = '0']) async* {
    for (var element in chaps) {
      String? link = element.querySelector('.chap')?.attributes['href'];
      int tmp = link!.indexOf('?');
      if (tmp > -1) {
        link = '${link.substring(0, tmp)}?style=list';
      } else {
        link = '$link?style=list';
      }
      String copertina = await _getCopertina(link);
      String title = element.querySelector('.chap > span')!.text;
      List<String> data = [
        title,
        volume,
        element.querySelector('.chap > i')!.text,
        link,
        copertina
      ];
      yield data;
    }
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
