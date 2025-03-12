import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/common/data/source/remote_manga_source.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga_info.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';

abstract interface class DetailsRepository {
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
  Future<Either<Failure, MangaInfo>> getMangaInfo({required Manga manga});
}
