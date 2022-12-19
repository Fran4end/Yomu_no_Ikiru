import 'package:manga_app/manga.dart';

class MangaBuilder {
  String? title;
  String? author;
  String? artist;
  String? status;
  String? trama;
  String? image;
  String? link;
  double? vote;
  double? readings;
  List? genres;
  List? chapters;

  build() {
    return Manga(builder: this);
  }
}
