part of 'explore_bloc.dart';

enum ExploreStatus { initial, loading, success, failure }

final class ExploreState {
  final List<Manga> mangaList;
  final bool hasReachedMax;
  final ExploreStatus status;
  final String? error;
  final int page;

  ExploreState({
    this.mangaList = const [],
    this.hasReachedMax = false,
    this.status = ExploreStatus.initial,
    this.error,
    this.page = 1,
  });

  ExploreState copyWith({
    List<Manga>? mangaList,
    bool? hasReachedMax,
    ExploreStatus? status,
    String? error,
    int? page,
  }) {
    return ExploreState(
      mangaList: mangaList ?? this.mangaList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
      error: error,
      page: page ?? this.page,
    );
  }

  @override
  String toString() {
    return "ExploreState { mangaList: $mangaList, hasReachedMax: $hasReachedMax, status: $status, error: $error }";
  }
}
