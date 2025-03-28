part of 'reader_bloc.dart';

@immutable
sealed class ReaderEvent {}

/// The event to get the new chapter
///
/// [manga] is the manga
/// [loadChapterIndex] is the index of the chapter to load
///
/// The event will be used to get the new chapter pages and emit the success or failure state
class ReaderNewChapter extends ReaderEvent {
  final Manga manga;
  final int loadChapterIndex;

  ReaderNewChapter({
    required this.manga,
    required this.loadChapterIndex,
  });
}

/// The event to get the next chapter
///
/// [manga] is the manga
/// [loadChapterIndex] is the index of the chapter to load
///
/// The event will be used to get the next chapter pages and emit the success or failure state
@Deprecated('Use `ReaderNewChapter` instead')
class ReaderNextChapter extends ReaderNewChapter {
  ReaderNextChapter({
    required super.manga,
    required super.loadChapterIndex,
  });
}

/// The event to get the previous chapter
///
/// [manga] is the manga
/// [loadChapterIndex] is the index of the chapter to load
///
/// The event will be used to get the previous chapter pages and emit the success or failure state
@Deprecated('Use `ReaderNewChapter` instead')
class ReaderPreviousChapter extends ReaderNewChapter {
  ReaderPreviousChapter({
    required super.manga,
    required super.loadChapterIndex,
  });
}

/// The event to show the app bar
///
/// [showAppBar] is the flag to show the app bar
///
/// The event will be used to show or hide the app bar
/// TODO: add more complex configuration for the app bar
class ReaderShowAppBar extends ReaderEvent {
  final bool showAppBar;

  ReaderShowAppBar({required this.showAppBar});
}

/// The event to change the orientation
///
/// The event will be used to change the orientation of the reader state in rotation
class ReaderChangeOrientation extends ReaderEvent {}
