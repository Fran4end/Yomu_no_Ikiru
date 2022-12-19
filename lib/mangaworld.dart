import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:manga_app/costants.dart';
import 'package:manga_app/manga.dart';
import 'package:manga_app/mangaBuilder.dart';

class MangaWorld {
  Future<Map<String, MangaBuilder>> getLastAdd() async {
    final res = await http.Client().get(Uri.parse('https://www.mangaworld.so'));
    if (res.statusCode == 200) {
      var page = parse(res.body);
      var mangaList = page
          .getElementsByClassName('comics-grid')[0]
          .getElementsByClassName('entry')
          .toList();
      mangaList.asMap().forEach((i, element) {
        MangaBuilder builder = MangaBuilder()
          ..status = _getStatus(element)
          ..title = _getTitle(element)
          ..link = _getLink(element)
          ..image = _getImage(element);
        mangasBuilder.update(
          builder.title.toString(),
          (value) => builder,
          ifAbsent: () => builder,
        );
        mangasBuilder.update(
          "last$i",
          (value) => builder,
          ifAbsent: () => builder,
        );
      });
    } else {
      if (kDebugMode) {
        print(throw Exception);
      }
    }
    return mangasBuilder;
  }

  Future<List<String>> buildSuggestions(String keyworld) async {
    List<String> sugg = [];
    final res = await http.Client().get(Uri.parse(
        'https://www.mangaworld.so/archive?sort=most_read&keyword=$keyworld'));
    if (res.statusCode == 200) {
      var page = parse(res.body);
      var mangaList = page
          .getElementsByClassName('comics-grid')[0]
          .getElementsByClassName('entry')
          .toList();
      for (var element in mangaList) {
        String title = _getTitle(element);
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
    final res = await http.Client().get(Uri.parse(
        'https://www.mangaworld.so/archive?sort=most_read&keyword=$keyworld'));
    if (res.statusCode == 200) {
      var page = parse(res.body);
      var mangaList = page
          .getElementsByClassName('comics-grid')[0]
          .getElementsByClassName('entry')
          .toList();
      mangaList.asMap().forEach((i, element) {
        MangaBuilder builder = MangaBuilder()
          ..status = _getStatus(element)
          ..title = _getTitle(element)
          ..link = _getLink(element)
          ..image = _getImage(element)
          ..trama = _getTrama(element);
        tmp.add(Manga(builder: builder));
        mangasBuilder.update(
          builder.title.toString(),
          (value) => builder,
          ifAbsent: () => builder,
        );
      });
    } else {
      if (kDebugMode) {
        print(throw Exception);
      }
    }
    return tmp;
  }

  _getLink(var element) {
    var obj = element.getElementsByClassName('thumb')[0].attributes;
    String link = obj["href"].toString();
    return link;
  }

  _getTitle(var element) {
    return element.getElementsByClassName('manga-title')[0].text;
  }

  _getStatus(var element) {
    return element.getElementsByClassName('status')[0].children[1].text;
  }

  _getImage(var element) {
    var obj = element.getElementsByTagName('img')[0].attributes;
    String link = obj["src"].toString();
    return link;
  }

  _getTrama(var element) {
    String temp = element.getElementsByClassName('story')[0].text;
    return temp.replaceAll('Trama: ', '');
  }

  Future getAllInfo(MangaBuilder builder) async {
    final res = await http.Client().get(Uri.parse(builder.link.toString()));
    if (res.statusCode == 200) {
      var page = parse(res.body);
      var info = page
          .getElementsByClassName('info')[0]
          .getElementsByClassName('meta-data')[0];
      var v = page
          .getElementsByClassName('info')[0]
          .getElementsByClassName('references')[0];
      builder
        ..artist = _getArtist(info)
        ..author = _getAuthor(info)
        ..genres = _getGenres(info)
        ..readings = double.parse(_getVisual(info))
        ..vote = double.parse(await _getVote(v));
    } else {
      if (kDebugMode) {
        print(throw Exception);
      }
    }
    return builder;
  }

  _getArtist(var element) {
    return element.children[3].getElementsByTagName('a')[0].text;
  }

  _getAuthor(var element) {
    return element.children[2].getElementsByTagName('a')[0].text;
  }

  _getGenres(var element) {
    List temp = [];
    List html = element.children[1].getElementsByTagName('a').toList();
    for (var element in html) {
      temp.add(element.text);
    }
    return temp;
  }

  _getVisual(var element) {
    return element.children[6].children[1].text;
  }

  _getVote(var element) async {
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
