import 'package:yomu_no_ikiru/features/manga/common/domain/entities/chapter.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/entities/manga_info.dart';

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
}

enum Status {
  ongoing,
  completed,
  dropped,
  onHold,
  cancelled,
  unknown,
}
