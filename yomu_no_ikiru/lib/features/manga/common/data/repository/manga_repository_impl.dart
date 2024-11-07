import 'package:fpdart/fpdart.dart';
import 'package:html/dom.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';
import 'package:yomu_no_ikiru/features/manga/common/data/model/manga_info_model.dart';
import 'package:yomu_no_ikiru/features/manga/common/data/model/manga_model.dart';
import 'package:yomu_no_ikiru/features/manga/common/data/source/remote_manga_source.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/entities/manga.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/entities/manga_info.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/repository/manga_repository.dart';

class MangaRepositoryImpl implements MangaRepository {
  MangaRepositoryImpl();

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
  Future<Either<Failure, Manga>> getMangaDetails({
    required String artist,
    required String author,
    required String coverUrl,
    required String id,
    required String link,
    required String source,
    required String status,
    required String title,
    required MangaRemoteDataSource remoteMangaSource,
  }) async {
    try {
      Document mangaPage = await remoteMangaSource.getMangaPage(link);
      MangaModel oldMangaModel = MangaModel(
        id: id,
        title: title,
        author: author,
        artist: artist,
        source: source,
        coverUrl: coverUrl,
        link: link,
        stat: status,
        genres: [],
        plot: '',
        index: 0,
        pageIndex: 0,
        chaps: [],
        mangaInfo: MangaInfoModel.empty(),
      );
      final mangaDetails = remoteMangaSource.getMangaDetails(mangaPage);
      mangaDetails.add(remoteMangaSource.getChapterList(mangaPage));
      MangaModel newMangaModel = oldMangaModel.copyWith(
        plot: mangaDetails[0],
        genres: mangaDetails[1],
        chaps: mangaDetails[2],
      );
      return right(newMangaModel);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, List<String>>>> getFilterMangaList({
    required MangaRemoteDataSource remoteMangaSource,
  }) async {
    //TODO: implement getFilterMangaList
    throw UnimplementedError();
    // return await remoteMangaSource.getFilterMangaList();
  }

  @override
  Future<Either<Failure, MangaInfo>> getMangaInfo({required Manga manga}) {
    // TODO: implement getMangaInfo
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<String>>> getChaptersPagesImage({
    required String chapterUrl,
    required MangaRemoteDataSource remoteMangaSource,
  }) async {
    try {
      final imageUrl = await remoteMangaSource.getChapterImagePagesUrl(chapterUrl);
      return right(imageUrl);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
