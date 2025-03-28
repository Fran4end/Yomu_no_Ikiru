import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/common/data/source/remote_manga_source.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';

abstract interface class ReaderRepository {
  /// Get the list of the chapter pages as links
  ///
  /// [chapterUrl] is the url of the chapter
  /// [remoteMangaSource] is the remote manga source
  Future<Either<Failure, List<String>>> getChaptersPagesImage({
    required String chapterUrl,
    required MangaRemoteDataSource remoteMangaSource,
  });
}
