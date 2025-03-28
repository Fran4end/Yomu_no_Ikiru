import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/common/data/source/remote_manga_source.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';

abstract interface class ExploreRepository {
  /// Get the latest manga list
  ///
  /// Return a [List<Manga>] that contains the latest manga in the site or the API.
  /// Return a [Failure] if the operation fails.
  Future<Either<Failure, List<Manga>>> getLatestMangaList();

  /// Get the popular manga list
  ///
  /// Return a list of manga that are the most popular in the site or the API
  /// Return a [Failure] if the operation fails.
  Future<Either<Failure, List<Manga>>> getPopularMangaList();

  /// Get the manga list based on the search query
  ///
  /// Return a list of manga that matches the search query and the filters.
  /// Return a [Failure] if the operation fails.
  Future<Either<Failure, List<Manga>>> getSearchMangaList({
    required MangaRemoteDataSource remoteMangaSource,
    required Map<String, dynamic> filters,
  });

  /// Get the list of filters that can be used
  ///
  /// Return a map that contains the filters that can be used to filter the manga list.
  /// Return a [Failure] if the operation fails.
  Future<Either<Failure, Map<String, List<String>>>> getFilterMangaList({
    required MangaRemoteDataSource remoteMangaSource,
  });
}
