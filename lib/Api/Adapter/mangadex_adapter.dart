import 'package:html/dom.dart';
import 'package:yomu_no_ikiru/Api/Apis/mangadex.dart';
import 'package:yomu_no_ikiru/Api/adapter.dart';
import 'package:yomu_no_ikiru/model/manga_builder.dart';

class MangaDexAdapter implements MangaApiAdapter {
  final MangaDex api = MangaDex();

  @override
  Map<String, List<MangaBuilder>> getLatestsAndPopular(Document document) {
    // TODO: implement getLatestsAndPopular
    throw UnimplementedError();
  }

  @override
  Future<List<MangaBuilder>> getResults(String keyword, [int page = 1]) async {
    final builders = await api.getResult(keyword, page);
    return builders;
  }

  @override
  Future<double> getVote([String link = ""]) async {
    return -1;
  }

  @override
  Future<MangaBuilder> getDetails(MangaBuilder builder, [String link = ""]) async {
    List values = await Future.wait([api.getUnloadInfo(builder), api.getChapters(builder.id!)]);
    builder = values[0];
    builder.chapters = values[1];
    return builder;
  }

  @override
  String get type => "MangaDex";

  @override
  Map<String, dynamic> toJson() => {"type": type};
}
