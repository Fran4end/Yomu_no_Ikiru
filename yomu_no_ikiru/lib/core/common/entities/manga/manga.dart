import 'package:collection/collection.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/chapter.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga_info.dart';

class Manga {
  final String id;
  final String title;
  final String author;
  final String artist;
  final Status status;
  final String plot;
  final String coverUrl;
  final String link;
  final MangaInfo info;
  final List<String> genres;
  final List<Chapter> chapters;
  final int index;
  final int pageIndex;
  final String source;

  Manga({
    required this.id,
    required this.title,
    required this.author,
    required this.artist,
    required this.status,
    required this.plot,
    required this.coverUrl,
    required this.link,
    required this.info,
    required this.genres,
    required this.chapters,
    required this.index,
    required this.pageIndex,
    required this.source,
  });

  @override
  String toString() {
    return 'Manga(id: $id, title: $title, author: $author, artist: $artist, status: $status, plot: $plot, imageUrl: $coverUrl, link: $link, info: $info, genres: $genres, chapters: $chapters, index: $index, pageIndex: $pageIndex, source: $source)';
  }

  @override
  bool operator ==(covariant Manga other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.title == title &&
        other.author == author &&
        other.artist == artist &&
        other.status == status &&
        other.plot == plot &&
        other.coverUrl == coverUrl &&
        other.link == link &&
        other.info == info &&
        listEquals(other.genres, genres) &&
        listEquals(other.chapters, chapters) &&
        other.index == index &&
        other.pageIndex == pageIndex &&
        other.source == source;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        author.hashCode ^
        artist.hashCode ^
        status.hashCode ^
        plot.hashCode ^
        coverUrl.hashCode ^
        link.hashCode ^
        info.hashCode ^
        genres.hashCode ^
        chapters.hashCode ^
        index.hashCode ^
        pageIndex.hashCode ^
        source.hashCode;
  }
}

enum Status {
  ongoing,
  completed,
  dropped,
  onHold,
  cancelled,
  unknown,
}
