import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';
import 'package:yomu_no_ikiru/core/usecase/usecase.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';
import 'package:yomu_no_ikiru/features/explore/domain/repository/explore_repository.dart';
import 'package:yomu_no_ikiru/core/usecase/generate_source.dart';

class SearchMangaList implements UseCase<List<Manga>, SearchMangaParams> {
  final ExploreRepository repository;

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
