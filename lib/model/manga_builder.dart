import 'package:flutter/foundation.dart';
import 'package:yomu_no_ikiru/Api/Adapter/mangaworld_adapter.dart';
import 'package:yomu_no_ikiru/model/manga_api_factory.dart';

import '../Api/adapter.dart';
import 'chapter.dart';
import 'manga.dart';

class MangaBuilder {
  String? id;
  String title = '';
  String image = '';
  String link = '';
  String? status;
  String? author;
  String? artist;
  String? plot;
  double? vote;
  double? readings;
  List<String> genres = [];
  List<Chapter> chapters = [];
  int index = 0;
  int pageIndex = 1;
  bool save = false;
  MangaApiAdapter api = MangaWorldAdapter();

  /// Sets the information for the [MangaBuilder].
  ///
  /// The `appBarInfo` setter method accepts a list parameter `values`, which contains the details to be set.
  ///
  /// The `values` list must have the following order:
  /// - **`values[0]`**: The readings value.
  /// - **`values[1]`**: The artist value. This is an optional value and will only be set if it's not already set.
  /// - **`values[2]`**: The author value. This is an optional value and will only be set if it's not already set.
  /// - **`values[3]`**: The genres value.
  /// - **`values[4]`**: The plot value.
  set appBarInfo(List values) {
    readings = values[0];
    artist ??= values[1];
    author ??= values[2];
    genres = values[3];
    plot = values[4];
  }

  /// Sets the title, image, and link for the [MangaBuilder].
  ///
  /// The `titleImageLink` setter method accepts a list parameter `values`, which contains the details to be set.
  /// It iterates over each value in the list. If a value is null, it sets it to 'Failed to load'.
  /// If the length of the first value (title) is greater than 55, it truncates it to 55 characters and appends '...'.
  ///
  /// The `values` list must have the following order:
  /// - **`values[0]`**: The title value. If its length is greater than 55, it will be truncated.
  /// - **`values[1]`**: The image value.
  /// - **`values[2]`**: The link value.
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

  /// Adds a new chapter to the `chapters` list in the [MangaBuilder] class.
  ///
  /// The `newChapter` method accepts a list parameter `value`, which contains the details of the new chapter.
  /// A new `Chapter` object is created using these values and added to the `chapters` list.
  ///
  /// The `value` list must have the following order:
  /// - **`value[0]`**: The unique identifier ([Chapter.id]).
  /// - **`value[1]`**: The title ([Chapter.title]). It can be null
  /// - **`value[2]`**: The publication date ([Chapter.date]). It can be null
  /// - **`value[3]`**: The link to the reading page ([Chapter.link]). It can be null
  /// - **`value[4]`**: The link to the cover image ([Chapter.cover]). It can be null
  /// - **`value[5]`**: The volume number ([Chapter.volume]). It can be null
  set newChapter(List value) {
    chapters.add(Chapter(
      id: value[0],
      title: value[1],
      date: value[2],
      link: value[3],
      cover: value[4],
      volume: value[5],
    ));
  }

  set newChapters(List<Chapter> chaps) {
    if (chapters.isEmpty) {
      chapters = chaps;
    } else {
      chapters = chapters.reversed.toList();
      chapters.addAll(chaps.reversed.toList().sublist(chapters.length));
      chapters = chapters.reversed.toList();
    }
  }

  set fromJson(Map json) {
    final apiBuilder = MangaApiFactory()..apiType = json["api"]["type"];
    try {
      id = json["id"];
      titleImageLink = [json['title'], json['image'], json['link']];
      status = json['status'];
      index = json['index'];
      pageIndex = json['pageIndex'];
      author = json['author'];
      artist = json['artist'];
      readings = json['readings'];
      plot = json['plot'];
      vote = json['vote'];
      genres = json['genres'].map<String>((e) => e.toString()).toList();
      chapters = json["chapters"].map<Chapter>((e) => Chapter.fromJson(e)).toList();
      api = apiBuilder.build();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Manga build() {
    id ??= "${api.type}_$title";
    artist ??= 'No artist found';
    author ??= 'No author found';
    readings ??= 0;
    status ??= 'Unknown status';
    plot ??= 'No trama found';
    vote ??= 0;
    return Manga(
      id: id!,
      artist: artist!,
      author: author!,
      chapters: chapters,
      genres: genres,
      image: image,
      index: index,
      link: link,
      pageIndex: pageIndex,
      readings: readings!,
      status: status!,
      title: title,
      plot: plot!,
      vote: vote!,
      api: api,
    );
  }

  @override
  String toString() {
    return build().toString();
  }
}
