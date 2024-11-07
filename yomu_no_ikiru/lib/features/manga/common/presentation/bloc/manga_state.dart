part of 'manga_bloc.dart';

enum MangaStatus { initial, loading, success, failure }

final class MangaState {
  final Manga? manga;
  final List<Manga>? mangaList;
  final bool hasReachedMax;
  final MangaStatus status;
  final String? error;
  final int page;

  const MangaState({
    this.manga,
    this.mangaList,
    this.hasReachedMax = false,
    this.status = MangaStatus.initial,
    this.error,
    this.page = 1,
  });

  MangaState copyWith({
    Manga? manga,
    List<Manga>? mangaList,
    bool? hasReachedMax,
    MangaStatus? status,
    String? error,
    int? page,
  }) {
    return MangaState(
      manga: manga,
      mangaList: mangaList ?? this.mangaList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
      error: error,
      page: page ?? this.page,
    );
  }

  @override
  String toString() {
    return "MangaState { manga: $manga, mangaList: $mangaList, hasReachedMax: $hasReachedMax, status: $status, error: $error }";
  }
}
