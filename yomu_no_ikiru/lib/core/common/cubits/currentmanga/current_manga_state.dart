part of 'current_manga_cubit.dart';

@immutable
sealed class CurrentMangaState {}

final class CurrentMangaInitial extends CurrentMangaState {}

final class CurrentMangaLoaded extends CurrentMangaState {
  final Manga manga;

  CurrentMangaLoaded(this.manga);
}
