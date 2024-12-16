import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/common/data/source/remote_manga_source.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';

abstract interface class ReaderRepository {
  Future<Either<Failure, List<String>>> getChaptersPagesImage({
    required String chapterUrl,
    required MangaRemoteDataSource remoteMangaSource,
  });
}
