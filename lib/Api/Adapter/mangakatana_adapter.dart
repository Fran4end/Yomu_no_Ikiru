import 'package:flutter/foundation.dart';
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
    builder.chapters = api.getChapters(document);
    builder.api = this;
    return builder;
  }

  @override
  List<String> getImageUrls(Document source) {
    List<String> imageUrls = [];
    try {
      var elements = source.querySelector("#imgs")!.querySelectorAll('img');
      for (var element in elements) {
        imageUrls.add(element.attributes['data-src']!);
      }
    } catch (e) {
      if (kDebugMode) {
        print('MangaKatana Line 31: $e');
      }
    }
    return imageUrls;
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

  @override
  bool get isJavaScript => true;

  @override
  Future<Document?> getDocument(String link) async => api.getPageDocument(link);
}
