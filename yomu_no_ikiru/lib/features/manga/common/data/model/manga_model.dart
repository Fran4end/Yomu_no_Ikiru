import 'dart:convert';

import 'package:yomu_no_ikiru/features/manga/common/data/model/chapter_model.dart';
import 'package:yomu_no_ikiru/features/manga/common/data/model/manga_info_model.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/entities/manga.dart';

class MangaModel extends Manga {
  final List<ChapterModel> chaps;
  final MangaInfoModel mangaInfo;
  final String stat;

  MangaModel({
    required super.id,
    required super.title,
    required super.author,
    required super.artist,
    required super.plot,
    required super.coverUrl,
    required super.link,
    required super.genres,
    required super.index,
    required super.pageIndex,
    required super.source,
    required this.stat,
    required this.chaps,
    required this.mangaInfo,
  }) : super(chapters: chaps, info: mangaInfo, status: Status.values.byName(stat));

  MangaModel copyWith({
    String? id,
    String? title,
    String? author,
    String? artist,
    String? stat,
    String? plot,
    String? coverUrl,
    String? link,
    MangaInfoModel? mangaInfo,
    List<String>? genres,
    List<ChapterModel>? chaps,
    int? index,
    int? pageIndex,
    String? source,
  }) {
    return MangaModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      artist: artist ?? this.artist,
      stat: stat ?? this.stat,
      plot: plot ?? this.plot,
      coverUrl: coverUrl ?? this.coverUrl,
      link: link ?? this.link,
      mangaInfo: mangaInfo ?? this.mangaInfo,
      genres: genres ?? this.genres,
      chaps: chaps ?? this.chaps,
      index: index ?? this.index,
      pageIndex: pageIndex ?? this.pageIndex,
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'author': author,
      'artist': artist,
      'status': stat,
      'plot': plot,
      'coverUrl': coverUrl,
      'link': link,
      'info': mangaInfo.toMap(),
      'genres': genres,
      'chapters': chaps.map((x) => x.toMap()).toList(),
      'index': index,
      'pageIndex': pageIndex,
      'source': source,
    };
  }

  factory MangaModel.fromMap(Map<String, dynamic> map) {
    return MangaModel(
      id: map['id'] as String,
      title: map['title'] as String,
      author: map['author'] as String,
      artist: map['artist'] as String,
      stat: map['status'] as String,
      plot: map['plot'] as String,
      coverUrl: map['coverUrl'] as String,
      link: map['link'] as String,
      mangaInfo: MangaInfoModel.fromMap(map['info'] as Map<String, dynamic>),
      genres: List<String>.from((map['genres'] as List<String>)),
      chaps: List<ChapterModel>.from(
        (map['chapters'] as List<int>).map<ChapterModel>(
          (x) => ChapterModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      index: map['index'] as int,
      pageIndex: map['pageIndex'] as int,
      source: map['source'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MangaModel.fromJson(String source) =>
      MangaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // factory MangaModel fromEntity(Manga manga) {
  //   return MangaModel(
  //     id: manga.id ,
  //     title: manga.title,
  //     author: manga.author,
  //     artist: manga.artist,
  //     stat: manga.status.name,
  //     plot: manga.plot,
  //     coverUrl: manga.coverUrl,
  //     link: manga.link,
  //     mangaInfo: manga.info,
  //     genres: manga.genres,
  //     chaps: manga.chapters,
  //     index: manga.index,
  //     pageIndex: manga.pageIndex,
  //     source: manga.source,
  //   );
  // }
}
