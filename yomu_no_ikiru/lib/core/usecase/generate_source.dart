import 'package:yomu_no_ikiru/core/common/data/source/remote_manga_source.dart';
import 'package:yomu_no_ikiru/core/common/data/source/sources/mangaworld_source.dart';

MangaRemoteDataSource generateSource(String source) {
  source = source.toLowerCase().trim();
  switch (source) {
    case "mangaworld":
      return MangaWorldSource();
    // case "MangaKatana":
    //   return MangaKatanaSource();
    default:
      throw Exception("Source not found");
  }
}
