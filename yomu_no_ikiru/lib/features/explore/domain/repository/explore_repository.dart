import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/common/data/source/remote_manga_source.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';

abstract interface class ExploreRepository {
  Future<Either<Failure, List<Manga>>> getLatestMangaList();
  Future<Either<Failure, List<Manga>>> getPopularMangaList();
  Future<Either<Failure, List<Manga>>> getSearchMangaList({
    required MangaRemoteDataSource remoteMangaSource,
    required Map<String, dynamic> filters,
  });
  Future<Either<Failure, Map<String, List<String>>>> getFilterMangaList({
    required MangaRemoteDataSource remoteMangaSource,
  });
}
