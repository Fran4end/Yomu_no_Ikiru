part of 'reader_bloc.dart';

Future<Either<Failure, List<String>>> _getImagePageUrls({
  required ReaderNewChapter event,
  required bool hasReachedMaxOrMin,
  required GetChapter getCurrentChapter,
}) async {
  final manga = event.manga;
  final remoteMangaSource = event.manga.source;
  if (hasReachedMaxOrMin) {
    return left(Failure("No more chapters"));
  }
  final res = await getCurrentChapter(
    GetCurrentChapterParams(
      chapterUrl: manga.chapters[event.loadChapterIndex].link,
      remoteMangaSource: remoteMangaSource,
    ),
  );
  return res;
}

onPointerSignal(PointerSignalEvent event, PageController pageController) {
  if (event is PointerScrollEvent) {
    if (event.scrollDelta.dy > 0) {
      pageController.nextPage(
        duration: const Duration(microseconds: 10),
        curve: Curves.easeInOut,
      );
    } else {
      pageController.previousPage(
        duration: const Duration(microseconds: 10),
        curve: Curves.easeInOut,
      );
    }
  }
}
