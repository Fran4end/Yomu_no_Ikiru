import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/common/data/model/manga_model.dart';
import 'package:yomu_no_ikiru/core/common/data/source/remote_manga_source.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';
import 'package:yomu_no_ikiru/features/explore/domain/repository/explore_repository.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  ExploreRepositoryImpl();

  @override
  Future<Either<Failure, List<Manga>>> getPopularMangaList() {
    // TODO: implement getPopularMangaList
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Manga>>> getLatestMangaList() {
    // TODO: implement getLatestMangaList
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Manga>>> getSearchMangaList({
    required MangaRemoteDataSource remoteMangaSource,
    required Map<String, dynamic> filters,
  }) async {
    try {
      filters['sort'] = 'most_read';
      List<MangaModel> mangaList = await remoteMangaSource.getSearchMangaList(filters);
      if (mangaList.isEmpty) {
        return left(Failure('No manga found'));
      }
      return right(mangaList);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Map<String, List<String>>>> getFilterMangaList({required MangaRemoteDataSource remoteMangaSource}) {
    // TODO: implement getFilterMangaList
    throw UnimplementedError();
  }
}
