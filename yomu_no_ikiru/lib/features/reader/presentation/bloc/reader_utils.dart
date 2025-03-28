part of 'reader_bloc.dart';

/// Method to get the image page urls
///
/// The method will get the image page urls from the current chapter
/// and return the list of image page urls.
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

/// Method for render the image pages without displaying it
void prefetchImages(List<String> pages, PageController pageController, {int bufferSize = 3}) {
  final currentPage = pageController.page?.toInt() ?? 0;

  // Preload previous and next images
  for (int offset = -bufferSize; offset <= bufferSize; offset++) {
    final targetIndex = currentPage + offset;
    if (targetIndex >= 0 && targetIndex < pages.length) {
      CachedNetworkImageProvider(pages[targetIndex]).resolve(const ImageConfiguration());
    }
  }
}
