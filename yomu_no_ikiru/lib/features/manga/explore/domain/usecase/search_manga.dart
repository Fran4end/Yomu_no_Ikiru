import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';
import 'package:yomu_no_ikiru/core/usecase/usecase.dart';
import 'package:yomu_no_ikiru/features/manga/common/data/repository/manga_repository_impl.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/entities/manga.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/usecases/generate_source.dart';

class SearchMangaList implements UseCase<List<Manga>, SearchMangaParams> {
  final MangaRepositoryImpl repository;

  SearchMangaList(this.repository);

  @override
  Future<Either<Failure, List<Manga>>> call(SearchMangaParams params) async {
    final source = generateSource(params.source);
    return await repository.getSearchMangaList(
      remoteMangaSource: source,
      filters: {
        'keyword': params.query,
        ...params.filters,
      },
    );
  }
}

class SearchMangaParams {
  final String source;
  final String query;
  final Map<String, dynamic> filters;

  SearchMangaParams({
    required this.source,
    required this.query,
    required this.filters,
  });
}
