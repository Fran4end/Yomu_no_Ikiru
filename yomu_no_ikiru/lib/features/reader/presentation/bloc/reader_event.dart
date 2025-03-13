part of 'reader_bloc.dart';

@immutable
sealed class ReaderEvent {}

class ReaderNewChapter extends ReaderEvent {
  final Manga manga;
  final int loadChapterIndex;

  ReaderNewChapter({
    required this.manga,
    required this.loadChapterIndex,
  });
}

class ReaderNextChapter extends ReaderNewChapter {
  ReaderNextChapter({
    required super.manga,
    required super.loadChapterIndex,
  });
}

class ReaderPreviousChapter extends ReaderNewChapter {
  ReaderPreviousChapter({
    required super.manga,
    required super.loadChapterIndex,
  });
}

class ReaderShowAppBar extends ReaderEvent {
  final bool showAppBar;

  ReaderShowAppBar({required this.showAppBar});
}

class ReaderChangeOrientation extends ReaderEvent {}
