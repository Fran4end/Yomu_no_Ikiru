import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:yomu_no_ikiru/Api/Apis/mangaworld.dart';
import 'package:yomu_no_ikiru/Api/adapter.dart';
import 'package:yomu_no_ikiru/model/manga_builder.dart';

class MangaWorldAdapter implements MangaApiAdapter {
  final api = MangaWorld();

  @override
  Future<double> getVote(MangaBuilder builder) async {
    Document? document = await api.getPageDocument(builder.link);
    return await api.getVote(document);
  }

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
    builder.api = this;
    return builder;
  }

  @override
  Map<String, dynamic> toJson() => {"type": type};

  @override
  String get type => "MangaWorld";

  @override
  List<String> getImageUrls(Document? source) {
    if (source == null) {
      return [];
    }
    List<String> imageUrls = [];
    try {
      var elements = source.querySelectorAll('#page > img');
      for (var element in elements) {
        imageUrls.add(element.attributes['src']!);
      }
    } catch (e) {
      if (kDebugMode) {
        print('ReaderPageController Line 142: $e');
      }
    }
    return imageUrls;
  }

  @override
  int get pageSize => 16;

  @override
  bool get isJavaScript => false;

  @override
  Future<Document?> getDocument(String link) async => api.getPageDocument(link);
}
