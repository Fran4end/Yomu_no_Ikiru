import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/common/data/source/remote_manga_source.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';
import 'package:yomu_no_ikiru/features/reader/domain/repository/reader_repository.dart';

class ReaderRepositoryImpl implements ReaderRepository {
  
  @override
  Future<Either<Failure, List<String>>> getChaptersPagesImage({
    required String chapterUrl,
    required MangaRemoteDataSource remoteMangaSource,
  }) async {
    try {
      final imageUrl = await remoteMangaSource.getChapterImagePagesUrl(chapterUrl);
      return right(imageUrl);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
  
}