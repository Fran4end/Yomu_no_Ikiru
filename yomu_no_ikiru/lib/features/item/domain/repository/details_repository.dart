import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/common/data/source/remote_manga_source.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga_info.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';

abstract interface class DetailsRepository {
  /// Get manga details from the remote source
  ///
  /// This method will get the manga details (such as plot) from the remote source and return it as a [Manga] object.
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

  /// Get manga info from the remote source
  ///
  /// This method will get the manga info (such as star ratings, members, etc.) from the remote source (like MyAnimeList) and return it as a [MangaInfo] object.
  Future<Either<Failure, MangaInfo>> getMangaInfo({required Manga manga});
}
