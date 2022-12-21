import 'package:manga_app/manga.dart';
import 'package:manga_app/manga_chaper.dart';

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
  List<String>? genres;
  Set<Chapter> chapters = {};

  set readingsVote(List<double?> value) {
    readings = value[0];
    vote = value[1];
  }

  set titleImageLink(List<String?> values) {
    for (var value in values) {
      value ??= 'Failed to load';
    }
    title = values[0]!;
    image = values[1]!;
    link = values[2]!;
  }

  set chap(List<String> value) {
    int volume;
    try {
      volume = int.parse(value[1]);
    } catch (e) {
      volume = 0;
    }
    chapters.toSet().add(Chapter(
          title: value[0],
          volume: volume,
          date: value[2],
          link: value[3],
          copertina: value[4],
        ));
  }

  build() {
    return Manga(builder: this);
  }
}
