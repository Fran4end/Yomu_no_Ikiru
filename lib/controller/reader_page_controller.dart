import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yomu_no_ikiru/view/widgets/Reader%20Page%20Widgets/reader_direction_icon.dart';

import '../Api/adapter.dart';
import '../constants.dart';
import '../model/manga.dart';
import '../view/widgets/Reader Page Widgets/reader_chapter_page.dart';

class ReaderPageController {
  static nextChapter({
    required BuildContext context,
    required Manga manga,
    required int chapterIndex,
    required Axis axis,
    required Widget icon,
    required bool reverse,
    required MangaApiAdapter api,
    required PageController pageController1,
    required Function(Manga) onScope,
    required Function(int page, int chapterIndex) onPageChange,
  }) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => ReaderChapterPage(
                  pageController1: pageController1,
                  pageIndex: 1,
                  manga: manga,
                  onScope: onScope,
                  axis: axis,
                  icon: icon,
                  reverse: reverse,
                  onPageChange: onPageChange,
                  chapterIndex: chapterIndex - 1,
                  api: api,
                )));
  }

  static previousChapter({
    required BuildContext context,
    required Manga manga,
    required int chapterIndex,
    required Axis axis,
    required Widget icon,
    required bool reverse,
    required MangaApiAdapter api,
    required PageController pageController1,
    required Function(Manga) onScope,
    required Function(int page, int chapterIndex) onPageChange,
  }) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => ReaderChapterPage(
                  pageController1: pageController1,
                  chapterIndex: chapterIndex + 1,
                  pageIndex: 1,
                  manga: manga,
                  onScope: onScope,
                  axis: axis,
                  icon: icon,
                  reverse: reverse,
                  onPageChange: onPageChange,
                  api: api,
                )));
  }

  static (Axis, Widget, bool) changeDirection({
    required Axis axis,
    required Widget icon,
    required bool reverse,
  }) {
    if (axis == Axis.vertical && reverse == false) {
      axis = Axis.horizontal;
      icon = const LeftRightIcon();
      reverse = false;
    } else if (reverse == false) {
      icon = const RightLeftIcon();
      reverse = true;
    } else {
      axis = Axis.vertical;
      icon = const TopDownIcon();
      reverse = false;
    }
    return (axis, icon, reverse);
  }

  static pageControllerListener({
    required List<String> imageUrls,
    required PageController pageController,
    required Manga manga,
    required int chapterIndex,
    required Function(int page, int chapterIndex) onPageChange,
  }) {
    onPageChange(pageController.page!.toInt(), (manga.chapters.length - chapterIndex) - 1);

    if (imageUrls.isNotEmpty) {
      if (pageController.page == imageUrls.length && chapterIndex - 1 >= 0) {
      } else if (pageController.page == 0 && chapterIndex + 1 < manga.chapters.length) {}
    }
  }

  static NativeAd loadAd() {
    return NativeAd(
      adUnitId: adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('$NativeAd loaded.');
        },
        onAdFailedToLoad: (ad, error) {
          // Dispose the ad here to free resources.
          debugPrint('$NativeAd failed to load: $error');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
      // Styling
      nativeTemplateStyle: adNativeTemplateStyle,
    )..load();
  }

  static void preloadImage(BuildContext context, String path) {
    precacheImage(CachedNetworkImageProvider(path), context);
    // final configuration = createLocalImageConfiguration(context);
    // CachedNetworkImageProvider(path).resolve(configuration);
  }

  static loadChapter({
    required Function(List<String>) onFinish,
    required String link,
    required WebViewController controller,
    required MangaApiAdapter api,
  }) async {
    if (api.isJavaScript) {
      controller
        ..loadRequest(
          Uri.parse(link),
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (url) async {
              var document = await controller
                  .runJavaScriptReturningResult('new XMLSerializer().serializeToString(document)');
              var dom = parse(json.decode(document.toString()));
              onFinish(api.getImageUrls(dom));
            },
          ),
        );
    } else {
      final Document? document = await api.getDocument(link);
      if (document == null) {
        onFinish([]);
      } else {
        onFinish(api.getImageUrls(document));
      }
    }
  }
}
