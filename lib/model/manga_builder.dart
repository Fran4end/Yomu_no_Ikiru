import 'package:manga_app/model/manga.dart';
import 'package:manga_app/model/chaper.dart';
import 'package:manga_app/model/utils.dart';

class MangaBuilder {
  String title = '';
  String image = '';
  String link = '';
  String? status;
  String? author;
  String? artist;
  String? trama;
  double? vote;
  double? readings;
  List<String> genres = [];
  Set<Chapter> chapters = {};
  int index = 0;
  int pageIndex = 0;
  bool save = false;

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

  set setChapIndex(int index) {
    if (index < 0) {
      Utils.showSnackBar('Error on save chapter bookmark');
    } else {
      this.index = index;
    }
  }

  set chap(List<String> value) {
    chapters.add(Chapter(
      title: value[0].replaceAll("Scan ITA", ""),
      date: value[1],
      link: value[2],
    ));
  }

  Manga build() {
    artist ??= 'No artist found';
    author ??= 'No author found';
    readings ??= 0;
    status ??= 'Unknow status';
    trama ??= 'No trama found';
    vote ??= 0;
    return Manga(
      artist: artist!,
      author: author!,
      chapters: chapters.toList(),
      genres: genres,
      image: image,
      index: index,
      link: link,
      pageIndex: pageIndex,
      readings: readings!,
      status: status!,
      title: title,
      trama: trama!,
      vote: vote!,
    );
  }
}
