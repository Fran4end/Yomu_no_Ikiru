part of 'details_bloc.dart';

@immutable
sealed class DetailsEvent {
  const DetailsEvent();
}

final class DetailsFetch extends DetailsEvent {
  final String id, link, title, author, artist, coverUrl, status, source;

  const DetailsFetch({
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

final class DetailsAlreadyLoaded extends DetailsEvent {
  final Manga manga;

  const DetailsAlreadyLoaded(this.manga);
}
