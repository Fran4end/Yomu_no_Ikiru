// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:yomu_no_ikiru/Api/Apis/mangadex.dart';
import 'package:yomu_no_ikiru/Api/adapter.dart';
import 'package:yomu_no_ikiru/model/manga_builder.dart';

// import '../../controller/utils.dart';

class MangaDexAdapter implements MangaApiAdapter {
  final MangaDex api = MangaDex();

  @override
  Future<List<MangaBuilder>> getResults(String keyword, [int page = 1]) async {
    final builders = await api.getResult(keyword, page);
    return builders;
  }

  @override
  Future<double> getVote(MangaBuilder builder) async {
    builder = await api.getUnloadInfo(builder);
    return 0;
  }

  @override
  Future<MangaBuilder> getDetails(MangaBuilder builder, [String link = ""]) async {
    builder.chapters = await api.getChapters(builder.id!);
    return builder;
  }

  @override
  String get type => "MangaDex";

  @override
  Map<String, dynamic> toJson() => {"type": type};

  @override
  List<String> getImageUrls(Document source) {
    // TODO: implement getImageUrls
    throw UnimplementedError();
  }
  // Future<List<String>> getImageUrls(dynamic source) async {
  //   if (source.runtimeType != String) {
  //     return [];
  //   }
  //   try {
  //     List<String> images = [];
  //     final res = await api.getJson(source);
  //     final baseUrl = res["baseUrl"];
  //     final hash = res["chapter"]["hash"];
  //     for (String image in res["chapter"]["dataSaver"]) {
  //       images.add("$baseUrl/data-saver/$hash/$image");
  //     }
  //     return images;
  //   } on DioException catch (e) {
  //     Utils.showSnackBar("Network problem");
  //     if (kDebugMode) {
  //       print(e.requestOptions.uri);
  //       print("MangaDex riga 48: $e");
  //     }
  //     return [];
  //   }
  // }

  @override
  int get pageSize => 16;
  
  @override
  bool get isJavaScript => false;
  
  @override
  Future<Document> getDocument(String link) {
    // TODO: implement getDocument
    throw UnimplementedError();
  }
}
