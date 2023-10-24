import 'package:html/dom.dart';
import 'package:yomu_no_ikiru/Api/Apis/mangaworld.dart';
import 'package:yomu_no_ikiru/Api/adapter.dart';
import 'package:yomu_no_ikiru/model/manga_builder.dart';

class MangaWorldAdapter implements MangaApiAdapter {
  final api = MangaWorld();

  @override
  Future<double> getVote([String link = ""]) async {
    Document? document = await api.getPageDocument(link);
    return await api.getVote(document);
  }

  @override
  Map<String, List<MangaBuilder>> getLatestsAndPopular(Document document) =>
      api.getLatestsAndPopular(document);

  @override
  Future<List<MangaBuilder>> getResults(String keyword, [int page = 1]) async {
    final list = await api.getResults(keyword, page);
    return list;
  }

  @override
  Future<MangaBuilder> getDetails(MangaBuilder builder, [String link = ""]) async {
    Document? document = await api.getPageDocument(link);
    builder = api.getAppBarInfo(builder, document);
    builder.chapters = api.getChapters(document);
    return builder;
  }

  @override
  Map<String, dynamic> toJson() => {"type": type};

  @override
  String get type => "MangaWorld";
}
