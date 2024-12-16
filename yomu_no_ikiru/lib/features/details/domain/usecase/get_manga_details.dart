import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';
import 'package:yomu_no_ikiru/core/usecase/usecase.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';
import 'package:yomu_no_ikiru/core/usecase/generate_source.dart';
import 'package:yomu_no_ikiru/features/details/data/repository/details_repository_impl.dart';

class GetMangaDetails implements UseCase<Manga, MangaDetailParams> {
  final DetailsRepositoryImpl repository;

  GetMangaDetails(this.repository);

  @override
  Future<Either<Failure, Manga>> call(MangaDetailParams params) async {
    final remoteSource = generateSource(params.source);
    return await repository.getMangaDetails(
      id: params.id,
      link: params.link,
      title: params.title,
      artist: params.artist,
      author: params.author,
      coverUrl: params.coverUrl,
      status: params.status,
      source: params.source,
      remoteMangaSource: remoteSource,
    );
  }
}

class MangaDetailParams {
  final String id, link, title, author, artist, coverUrl, status, source;

  MangaDetailParams({
    required this.id,
    required this.link,
    required this.title,
    required this.author,
    required this.artist,
    required this.coverUrl,
    required this.status,
    required this.source,
  });
}
