import 'package:manga_app/model/chaper.dart';

class Manga {
  final String title;
  final String author;
  final String artist;
  final String status;
  final String trama;
  final String image;
  final String link;
  final double vote;
  final double readings;
  final List<String> genres;
  final List<Chapter> chapters;
  final int index;
  final int pageIndex;

  Manga({
    required this.title,
    required this.author,
    required this.artist,
    required this.status,
    required this.trama,
    required this.image,
    required this.link,
    required this.vote,
    required this.readings,
    required this.genres,
    required this.chapters,
    required this.index,
    required this.pageIndex,
  });

  Manga.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        image = json['image'],
        link = json['link'],
        trama = json['trama'],
        status = json['status'],
        artist = json['artist'],
        author = json['author'],
        genres = json['genres'],
        vote = json['vote'],
        chapters = json['chapters'],
        readings = json['readings'],
        index = json['index'],
        pageIndex = json['pageIndex'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'image': image,
        'link': link,
        'trama': trama,
        'status': status,
        'artist': artist,
        'author': author,
        'genres': genres,
        'vote': vote,
        'chapters': chapters,
        'readings': readings,
        'index': index,
        'pageIndex': pageIndex,
      };

  Map<String, dynamic> toJsonOnlyBookmark() => {
        'title': title,
        'image': image,
        'link': link,
        'index': index,
        'pageIndex': pageIndex,
      };

  @override
  String toString() {
    return '$title -> ($author, $artist): $status ($vote, $readings) \n[$trama] $genres\n$image\n$link\n\n';
  }
}
