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
      var mangaList =
          page.getElementsByClassName('comics-grid')[0].children.toList();
      for (var element in mangaList) {
        String status = _getStatus(element.children.toList());
        String title = _getTitle(element.children.toList());
        String link = _getLink(element.children.toList());
        String image = _getImage(element.children.toList());
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

  Future<List<Manga>> getArchive() async {
    List<Manga> mangas = [];
    final res = await http.Client().get(Uri.parse(
        'https://api.allorigins.win/raw?url=https://www.mangaworld.so/archive'));
    final res2 = await http.Client().get(Uri.parse(
        'https://api.allorigins.win/raw?url=https://www.mangaworld.so/archive?page=2'));
    if (res.statusCode == 200 && res2.statusCode == 200) {
      var page = parse(res.body);
      var page2 = parse(res2.body);
      var mangaList =
          page.getElementsByClassName('comics-grid')[0].children.toList();
      mangaList.addAll(
          page2.getElementsByClassName('comics-grid')[0].children.toList());
      for (var element in mangaList) {
        String status = _getStatus(element.children.toList());
        String artist = _getArtist(element.children.toList());
        String author = _getAuthor(element.children.toList());
        String title = _getTitle(element.children.toList());
        String trama = _getTrama(element.children.toList());
        String image = _getImage(element.children.toList());
        String link = _getLink(element.children.toList());
        List genres = _getGenres(element.children.toList());
        mangas.add(Manga(
            genres: genres,
            status: status,
            title: title,
            artist: artist,
            author: author,
            image: image,
            trama: trama,
            link: link));
      }
      return mangas;
    } else {
      return throw Exception;
    }
  }

  Future<List<Manga>> getResults(String keyworld) async {
    List<Manga> mangas = [];
    final res = await http.Client().get(Uri.parse(
        'https://api.allorigins.win/raw?url=https://www.mangaworld.so/archive?keyword=$keyworld&sort=most_read'));
    if (res.statusCode == 200) {
      var page = parse(res.body);
      var mangaList =
          page.getElementsByClassName('comics-grid')[0].children.toList();
      for (var element in mangaList) {
        String status = _getStatus(element.children.toList());
        String artist = _getArtist(element.children.toList());
        String author = _getAuthor(element.children.toList());
        String title = _getTitle(element.children.toList());
        String trama = _getTrama(element.children.toList());
        String image =
            'https://api.allorigins.win/raw?url=${_getImage(element.children.toList())}';
        String link = _getLink(element.children.toList());
        List genres = _getGenres(element.children.toList());
        mangas.add(Manga(
            genres: genres,
            status: status,
            title: title,
            artist: artist,
            author: author,
            image: image,
            trama: trama,
            link: link));
      }
      return mangas;
    } else {
      return throw Exception;
    }
  }

  _getLink(var element) {
    var obj = element[0].attributes;
    String link = obj["href"].toString();
    return link;
  }

  _getTitle(var element) {
    return element[1].children[0].text;
  }

  _getStatus(var element) {
    return element[1].children[2].children[1].text;
  }

  _getArtist(var element) {
    return element[1].children[5].children[1].text;
  }

  _getAuthor(var element) {
    return element[1].children[5].children[1].text;
  }

  _getTrama(var element) {
    String temp = element[1].children[7].text;
    return temp.replaceAll('Trama: ', '');
  }

  _getImage(var element) {
    var obj = element[0].firstChild.attributes;
    String link = obj["src"].toString();
    return link;
  }

  _getGenres(var element) {
    List temp = [];
    for (var element in element[1].children[6].children.toList()) {
      if (element.text != 'Generi: ' && element.text != '') {
        temp.add(element.text);
      }
    }
    return temp;
  }
}
