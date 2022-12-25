import 'package:manga_app/manga_builder.dart';
import 'package:manga_app/chaper.dart';

class Manga {
  final String? title;
  final String? author;
  final String? artist;
  final String? status;
  final String? trama;
  final String? image;
  final String? link;
  final double? vote;
  final double? readings;
  final List<String> genres;
  final List<Chapter> chapters;

  Manga({required MangaBuilder builder})
      : title = builder.title,
        image = builder.image,
        link = builder.link,
        trama = builder.trama,
        status = builder.status,
        artist = builder.artist,
        author = builder.author,
        genres = builder.genres,
        vote = builder.vote,
        chapters = builder.chapters.toList(),
        readings = builder.readings;

  @override
  String toString() {
    return '$title -> ($author, $artist): $status ($vote, $readings) \n[$trama] $genres\n$image\n$link\n\n';
  }
}
