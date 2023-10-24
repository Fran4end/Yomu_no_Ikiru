import 'package:flutter/services.dart';
import 'package:yomu_no_ikiru/Api/Adapter/mangadex_adapter.dart';
import 'package:yomu_no_ikiru/Api/Adapter/mangaworld_adapter.dart';
import 'package:yomu_no_ikiru/Api/adapter.dart';

class MangaApiFactory {
  MangaApiAdapter? api;

  set apiType(String type) {
    switch (type) {
      case "MangaWorld":
        api = MangaWorldAdapter();
        break;
      case "MangaDex":
        api = MangaDexAdapter();
        break;
      default:
        api = null;
    }
  }

  MangaApiAdapter build() {
    if (api == null) {
      return throw MissingPluginException;
    } else {
      return api!;
    }
  }
}
