import 'package:fpdart/fpdart.dart';
import 'package:html/dom.dart';
import 'package:yomu_no_ikiru/core/common/data/model/manga_info_model.dart';
import 'package:yomu_no_ikiru/core/common/data/model/manga_model.dart';
import 'package:yomu_no_ikiru/core/common/data/source/remote_manga_source.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga_info.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';
import 'package:yomu_no_ikiru/features/item/domain/repository/details_repository.dart';

class DetailsRepositoryImpl implements DetailsRepository {
  DetailsRepositoryImpl();

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
  Future<Either<Failure, MangaInfo>> getMangaInfo({required Manga manga}) {
    // TODO: implement getMangaInfo
    throw UnimplementedError();
  }
}
