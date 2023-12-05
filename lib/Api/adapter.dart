import 'package:html/dom.dart';
import 'package:yomu_no_ikiru/model/manga_builder.dart';

abstract class MangaApiAdapter {
  final String type = "";
  final int pageSize = 16;
  final bool isJavaScript = false;
  Future<MangaBuilder> getDetails(MangaBuilder builder, [String link = ""]);
  Future<double> getVote(MangaBuilder builder);
  Future<List<MangaBuilder>> getResults(String keyword, [int page = 1]);
  List<String> getImageUrls(Document source);
  Future<Document?> getDocument(String link);
  Map<String, dynamic> toJson() {
    return {"type": type};
  }
}
