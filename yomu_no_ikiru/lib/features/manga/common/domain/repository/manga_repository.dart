import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';
import 'package:yomu_no_ikiru/features/manga/common/data/source/remote_manga_source.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/entities/manga.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/entities/manga_info.dart';

abstract interface class MangaRepository {
  Future<Either<Failure, List<Manga>>> getLatestMangaList();
  Future<Either<Failure, List<Manga>>> getPopularMangaList();
  Future<Either<Failure, List<Manga>>> getSearchMangaList({
    required MangaRemoteDataSource remoteMangaSource,
    required Map<String, dynamic> filters,
  });
  Future<Either<Failure, Manga>> getMangaDetails({
    required String id,
    required String link,
    required String title,
    required String author,
    required String artist,
    required String coverUrl,
    required String status,
    required String source,
    required MangaRemoteDataSource remoteMangaSource,
  });
  Future<Either<Failure, Map<String, List<String>>>> getFilterMangaList({
    required MangaRemoteDataSource remoteMangaSource,
  });
  Future<Either<Failure, MangaInfo>> getMangaInfo({required Manga manga});
  Future<Either<Failure, List<String>>> getChaptersPagesImage({
    required String chapterUrl,
    required MangaRemoteDataSource remoteMangaSource,
  });
}
