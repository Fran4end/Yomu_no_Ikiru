import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';
import 'package:yomu_no_ikiru/core/usecase/usecase.dart';
import 'package:yomu_no_ikiru/core/usecase/generate_source.dart';
import 'package:yomu_no_ikiru/features/reader/domain/repository/reader_repository.dart';

class GetChapter implements UseCase<List<String>, GetCurrentChapterParams> {
  final ReaderRepository repository;

  GetChapter(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(GetCurrentChapterParams params) async {
    final source = generateSource(params.remoteMangaSource);
    return await repository.getChaptersPagesImage(
      chapterUrl: params.chapterUrl,
      remoteMangaSource: source,
    );
  }
}

class GetCurrentChapterParams {
  final String chapterUrl;
  final String remoteMangaSource;

  GetCurrentChapterParams({
    required this.chapterUrl,
    required this.remoteMangaSource,
  });
}
