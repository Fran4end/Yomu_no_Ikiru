import 'package:html/dom.dart';
import 'package:yomu_no_ikiru/model/manga_builder.dart';

abstract class MangaApiAdapter {
  final String type = "";
  Future<MangaBuilder> getDetails(MangaBuilder builder, [String link = ""]);
  Future<double> getVote([String link = ""]);
  Future<List<MangaBuilder>> getResults(String keyword, [int page = 1]);
  Map<String, List<MangaBuilder>> getLatestsAndPopular(Document document);
  Map<String, dynamic> toJson() {
    return {"type": type};
  }
}