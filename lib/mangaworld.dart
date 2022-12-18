import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:manga_app/manga.dart';

class MangaWorld {
  Future<List<Manga>> getLastAdd() async {
    List<Manga> mangas = [];
    final res = await http.Client().get(Uri.parse(
        'https://api.allorigins.win/raw?url=https://www.mangaworld.so'));
    if (res.statusCode == 200) {
      var page = parse(res.body);
      var mangaList = page
          .getElementsByClassName('comics-grid')[0]
          .getElementsByClassName('entry')
          .toList();
      for (var element in mangaList) {
        String status = _getStatus(element);
        String title = _getTitle(element);
        String link = _getLink(element);
        String image = _getImage(element);
        mangas.add(Manga(
          image: image,
          status: status,
          title: title,
          link: link,
        ));
      }
      return mangas;
    } else {
      return throw Exception;
    }
  }

  Future<List<String>> buildSuggestions(String keyworld) async {
    List<String> sugg = [];
    final res = await http.Client().get(Uri.parse(
        'https://api.allorigins.win/raw?url=https://www.mangaworld.so/archive?sort=most_read&keyword=$keyworld'));
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
      return sugg;
    } else {
      return throw Exception;
    }
  }

  Future<List<Manga>> getResults(String keyworld) async {
    List<Manga> mangas = [];
    final res = await http.Client().get(Uri.parse(
        'https://api.allorigins.win/raw?url=https://www.mangaworld.so/archive?sort=most_read&keyword=$keyworld'));
    if (res.statusCode == 200) {
      var page = parse(res.body);
      var mangaList = page
          .getElementsByClassName('comics-grid')[0]
          .getElementsByClassName('entry')
          .toList();
      for (var element in mangaList) {
        String status = _getStatus(element);
        String title = _getTitle(element);
        String image = _getImage(element);
        String link = _getLink(element);
        var tmp = Manga(
          status: status,
          title: title,
          image: image,
          link: link,
        );

        mangas.add(tmp);
      }
      return mangas;
    } else {
      return throw Exception;
    }
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

  _getArtist(var element) {
    return element.getElementsByClassName('artist')[0].children[1].text;
  }

  _getAuthor(var element) {
    return element.getElementsByClassName('author')[0].children[1].text;
  }

  _getTrama(var element) {
    String temp = element.getElementsByClassName('story')[0].text;
    return temp.replaceAll('Trama: ', '');
  }

  _getImage(var element) {
    var obj = element.getElementsByTagName('img')[0].attributes;
    String link = obj["src"].toString();
    return link;
  }

  _getGenres(var element) {
    List temp = [];
    List html = element.getElementsByClassName('genres').children.toList();
    for (var element in html) {
      if (element.text != 'Generi: ' && element.text != '') {
        temp.add(element.text);
      }
    }
    return temp;
  }
}
