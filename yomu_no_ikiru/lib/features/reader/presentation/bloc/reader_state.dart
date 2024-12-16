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
  final bool isLoadingNewChapter;
  final bool showAppBar;
  final bool isSliding;
  final ReaderOrientationType orientation;

  ReaderSuccess({
    required this.manga,
    this.rawPages = const {},
    this.currentPage = 1,
    this.currentChapter = 0,
    this.isLoadingNewChapter = false,
    this.showAppBar = false,
    this.isSliding = false,
    this.orientation = ReaderOrientationType.orientalHorizontal,
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
    bool? isSliding,
    ReaderOrientationType? orientation,
  }) {
    return ReaderSuccess(
      manga: manga ?? this.manga,
      rawPages: rawPages ?? this.rawPages,
      currentPage: currentPage ?? this.currentPage,
      isLoadingNewChapter: isLoadingNewChapter ?? this.isLoadingNewChapter,
      currentChapter: currentChapter ?? this.currentChapter,
      showAppBar: showAppBar ?? this.showAppBar,
      orientation: orientation ?? this.orientation,
      isSliding: isSliding ?? this.isSliding,
    );
  }
}

final class ReaderFailure extends ReaderState {
  final String error;

  ReaderFailure({required this.error});
}
