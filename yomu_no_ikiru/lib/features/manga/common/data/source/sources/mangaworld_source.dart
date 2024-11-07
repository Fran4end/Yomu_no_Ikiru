import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:yomu_no_ikiru/core/error/exceptions.dart';
import 'package:yomu_no_ikiru/features/manga/common/data/model/chapter_model.dart';
import 'package:yomu_no_ikiru/features/manga/common/data/model/manga_info_model.dart';
import 'package:yomu_no_ikiru/features/manga/common/data/model/manga_model.dart';
import 'package:yomu_no_ikiru/features/manga/common/data/source/remote_manga_source.dart';

class MangaWorldSource implements MangaRemoteDataSource {
  @override
  Dio get dio => Dio(BaseOptions(baseUrl: 'https://mangaworld.ac'));

  @override
  DateTime getFormattedDate(String date) {
    date = date.toLowerCase().trim();
    final format = DateFormat('d MMMM y', 'it');
    return format.parse(date);
  }

  @override
  List<ChapterModel> getChapterList(Document mangaPage) {
    List<ChapterModel> chapters = [];
    List<Element> chaptersElement =
        mangaPage.querySelector('.chapters-wrapper')!.querySelectorAll('.chapter > .chap');
    int n = chaptersElement.length;
    for (var chap in chaptersElement) {
      Map attributes = chap.attributes;
      String link = attributes['href'];
      int tmp = link.indexOf('?');
      if (tmp > -1) {
        link = '${link.substring(0, tmp)}?style=list';
      } else {
        link = '$link?style=list';
      }
      List<String> data = [
        attributes['title']
            .toString()
            .substring(attributes['title'].toString().indexOf("C"))
            .replaceAll("Scan ITA", ""),
        chap.querySelector('i')!.text.trim(),
        link,
      ];
      chapters.add(
        ChapterModel(
          id: "MangaWorld_${data[0]}",
          date: getFormattedDate(data[1]),
          title: data[0],
          link: data[2],
          cover: '',
          volume: 0,
          order: n--,
        ),
      );
    }
    return chapters.reversed.toList();
  }

  @override
  Future<Map<String, List<String>>> getFilterMangaList() async {
    try {
      Response res = await dio.get('/archive');
      if (res.statusCode == 200) {
        Document document = parse(res.data);
        var filters = document.querySelector('.filters')!.children;
        return Map.fromEntries(
          filters
              .map(
                (e) {
                  var filterName = e.classes.first;
                  if (filterName.contains('search')) {
                    return null;
                  }
                  var filterValues = e.children[1].children.map((e) => e.text).toList();
                  return MapEntry(filterName, filterValues);
                },
              )
              .where((element) => element != null)
              .cast<MapEntry<String, List<String>>>(),
        );
      } else {
        throw const ServerException('Failed to load data');
      }
    } on DioException {
      throw NoConnectionException();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MangaModel>> getLatestMangaList() {
    // TODO: implement getLatestMangaList
    throw UnimplementedError();
  }

  @override
  List getMangaDetails(Document mangaPage) {
    var info = mangaPage.querySelector('.info > .meta-data');
    return [
      info?.querySelector('#noidungm')?.text,
      info?.children[1].querySelectorAll('a').map((e) => e.text).toList(),
    ];
  }

  @override
  Future<Document> getMangaPage(String mangaUrl) async {
    try {
      Response res = await dio.get(mangaUrl);
      if (res.statusCode == 200) {
        Document document = parse(res.data);
        return document;
      } else {
        throw const ServerException('Failed to load data');
      }
    } on DioException {
      throw NoConnectionException();
    }
  }

  @override
  Future<List<MangaModel>> getPopularMangaList() {
    // TODO: implement getPopularMangaList
    throw UnimplementedError();
  }

  @override
  Future<List<MangaModel>> getSearchMangaList(Map<String, dynamic> filters) async {
    try {
      Response res = await dio.get('/archive', queryParameters: filters);
      if (res.statusCode == 200) {
        Document document = parse(res.data);
        if (document.querySelector('.comics-grid')!.children.isEmpty) {
          return [];
        }
        var mangaList = document.querySelectorAll('.comics-grid > .entry');
        return mangaList.map(
          (mangaItem) {
            final link = mangaItem.querySelector('.thumb')?.attributes['href'] ?? '';
            final id = link.split('/').reversed.elementAt(1);
            return MangaModel(
              id: 'MangaWorld-$id',
              title: mangaItem.querySelector('.name > .manga-title')?.text ?? '',
              link: link,
              coverUrl: mangaItem.querySelector('.thumb > img')?.attributes['src'] ?? '',
              artist: mangaItem.querySelector('.content > .artist > a')?.text ?? '',
              author: mangaItem.querySelector('.content > .author > a')?.text ?? '',
              stat: translateStatus(mangaItem.querySelector('.content > .status > a')?.text ?? ''),
              plot: '',
              source: 'MangaWorld',
              mangaInfo: MangaInfoModel.empty(),
              genres: [],
              index: 0,
              pageIndex: 0,
              chaps: [],
            );
          },
        ).toList();
      } else {
        throw const ServerException('Failed to load data');
      }
    } on DioException {
      throw NoConnectionException();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  String translateStatus(String status) {
    switch (status) {
      case 'In corso':
        return 'ongoing';
      case 'Finito':
        return 'completed';
      case 'In pausa':
        return 'onHold';
      case 'Dropped':
        return 'dropped';
      case 'Annullato':
        return 'cancelled';
      default:
        return 'unknown';
    }
  }

  @override
  Future<List<String>> getChapterImagePagesUrl(String chapterUrl) async {
    try {
      Response res = await dio.get(chapterUrl);
      if (res.statusCode == 200) {
        Document document = parse(res.data);
        var imagePages = document.querySelectorAll('#page > img');
        return imagePages.map((e) => e.attributes['src']!).toList();
      } else {
        throw const ServerException('Failed to load data');
      }
    } on DioException {
      throw NoConnectionException();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
