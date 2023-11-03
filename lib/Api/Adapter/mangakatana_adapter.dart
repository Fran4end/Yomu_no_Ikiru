import 'package:html/dom.dart';
import 'package:yomu_no_ikiru/Api/Apis/mangakatana.dart';
import 'package:yomu_no_ikiru/Api/adapter.dart';
import 'package:yomu_no_ikiru/model/manga_builder.dart';

class MangaKatanaAdapter implements MangaApiAdapter {
  final api = MangaKatana();
  @override
  Future<MangaBuilder> getDetails(MangaBuilder builder, [String link = ""]) async {
    Document? document = await api.getPageDocument(link);
    builder = api.getAppBarInfo(builder, document);
    return builder;
  }

  @override
  Future<List<String>> getImageUrls(String link) {
    // TODO: implement getImageUrls
    throw UnimplementedError();
  }

  @override
  Map<String, List<MangaBuilder>> getLatestsAndPopular(Document document) {
    // TODO: implement getLatestsAndPopular
    throw UnimplementedError();
  }

  @override
  Future<List<MangaBuilder>> getResults(String keyword, [int page = 1]) async {
    return await api.getResults(keyword, page);
  }

  @override
  Future<double> getVote(MangaBuilder builder) async => 0;

  @override
  Map<String, dynamic> toJson() => {"type": type};
  @override
  String get type => "MangaKatana";

  @override
  int get pageSize => 20;
}
