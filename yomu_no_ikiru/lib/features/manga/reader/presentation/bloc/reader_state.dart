part of 'reader_bloc.dart';

@immutable
sealed class ReaderState {}

final class ReaderInitial extends ReaderState {}

final class ReaderLoading extends ReaderState {}

final class ReaderSuccess extends ReaderState {
  final Manga manga;
  final Map<int, List<String>> rawPages;
  final int currentPage;
  final int currentChapter;
  // final bool hasReachedMax;
  // final bool hasReachedMin;
  final bool isLoadingNewChapter;
  final bool showAppBar;

  ReaderSuccess({
    required this.manga,
    this.rawPages = const {},
    this.currentPage = 0,
    this.currentChapter = 0,
    // this.hasReachedMax = false,
    // this.hasReachedMin = false,
    this.isLoadingNewChapter = false,
    this.showAppBar = false,
  });

  int get chapterSize => rawPages[currentChapter]?.length ?? 0;
  List<String> get pages => rawPages[currentChapter] ?? [];

  ReaderSuccess copyWith({
    Manga? manga,
    Map<int, List<String>>? rawPages,
    int? currentPage,
    int? currentChapter,
    bool? hasReachedMax,
    bool? hasReachedMin,
    bool? isLoadingNewChapter,
    bool? showAppBar,
  }) {
    return ReaderSuccess(
      manga: manga ?? this.manga,
      rawPages: rawPages ?? this.rawPages,
      currentPage: currentPage ?? this.currentPage,
      // hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      // hasReachedMin: hasReachedMin ?? this.hasReachedMin,
      isLoadingNewChapter: isLoadingNewChapter ?? this.isLoadingNewChapter,
      currentChapter: currentChapter ?? this.currentChapter,
      showAppBar: showAppBar ?? this.showAppBar,
    );
  }
}

final class ReaderFailure extends ReaderState {
  final String error;

  ReaderFailure({required this.error});
}
