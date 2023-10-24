import 'package:yomu_no_ikiru/Api/adapter.dart';

import 'chapter.dart';

class Manga {
  final String id;
  final String title;
  final String author;
  final String artist;
  final String status;
  final String plot;
  final String image;
  final String link;
  final double vote;
  final double readings;
  final List<String> genres;
  final List<Chapter> chapters;
  final int index;
  final int pageIndex;
  final MangaApiAdapter api;
  Manga({
    required this.api,
    required this.id,
    required this.title,
    required this.author,
    required this.artist,
    required this.status,
    required this.plot,
    required this.image,
    required this.link,
    required this.vote,
    required this.readings,
    required this.genres,
    required this.chapters,
    required this.index,
    required this.pageIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'title': title,
      'image': image,
      'link': link,
      'plot': plot,
      'status': status,
      'artist': artist,
      'author': author,
      'genres': genres,
      'vote': vote,
      'chapters': chapters.map((e) => e.toJson()).toList(),
      'readings': readings,
      'index': index,
      'pageIndex': pageIndex,
      'api': api.toJson(),
    };
  }

  @override
  String toString() {
    return '$id || $title -> ($author, $artist): $status ($vote, $readings)\n$genres\n$image\n$link\n\n';
  }
}
