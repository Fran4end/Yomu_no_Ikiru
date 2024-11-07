part of 'manga_bloc.dart';

@immutable
sealed class MangaEvent {
  const MangaEvent();
}

final class MangaFetchDetails extends MangaEvent {
  final String id, link, title, author, artist, coverUrl, status, source;

  const MangaFetchDetails({
    required this.id,
    required this.link,
    required this.title,
    required this.author,
    required this.artist,
    required this.coverUrl,
    required this.status,
    required this.source,
  });
}

final class MangaFetchSearchList extends MangaEvent {
  final String source;
  final int maxPagesize;
  final String query;
  final Map<String, dynamic> filters;

  const MangaFetchSearchList({
    required this.maxPagesize,
    required this.source,
    required this.filters,
    this.query = "",
  });
}

final class MangaResetList extends MangaEvent {
  final bool toEmpty;

  const MangaResetList([this.toEmpty = false]);
}

final class MangaDispose extends MangaEvent {}
