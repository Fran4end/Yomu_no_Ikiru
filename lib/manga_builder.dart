import 'package:manga_app/manga.dart';
import 'package:manga_app/chaper.dart';

class MangaBuilder {
  late String title;
  late String image;
  late String link;
  String? status;
  String? author;
  String? artist;
  String? trama;
  double? vote;
  double? readings;
  List<String> genres = [];
  Set<Chapter> chapters = {};

  set readingsVote(List<double?> value) {
    readings = value[0];
    vote = value[1];
  }

  set titleImageLink(List<String?> values) {
    for (var value in values) {
      value ??= 'Failed to load';
    }
    if (values[0]!.length > 55) {
      values[0] = '${values[0]?.substring(0, 55)}...';
    }
    title = values[0]!;
    image = values[1]!;
    link = values[2]!;
  }

  set chap(List<String> value) {
    chapters.add(Chapter(
      title: value[0],
      date: value[1],
      link: value[2],
    ));
  }

  build() {
    return Manga(builder: this);
  }
}
