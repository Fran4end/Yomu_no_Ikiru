import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yomu_no_ikiru/model/chapter.dart';
import 'package:yomu_no_ikiru/view/widgets/Reader%20Page%20Widgets/next_chapter_page_widget.dart';

import '../Api/adapter.dart';
import '../constants.dart';
import '../model/manga_builder.dart';
import '../view/Pages/reader_page.dart';
import '../view/widgets/Reader Page Widgets/prev_chapter_page_widget.dart';

class ReaderPageController {
  static nextChapter({
    required BuildContext context,
    required MangaBuilder builder,
    required int chapterIndex,
    required Axis axis,
    required Widget icon,
    required bool reverse,
    required MangaApiAdapter api,
    required Function(MangaBuilder) onScope,
    required Function(int page, int chapterIndex) onPageChange,
  }) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => Reader(
                  pageIndex: 1,
                  builder: builder,
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
    required MangaBuilder builder,
    required int chapterIndex,
    required Axis axis,
    required Widget icon,
    required bool reverse,
    required MangaApiAdapter api,
    required Function(MangaBuilder) onScope,
    required Function(int page, int chapterIndex) onPageChange,
  }) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => Reader(
                  chapterIndex: chapterIndex + 1,
                  pageIndex: 1,
                  builder: builder,
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
      icon = Stack(
        alignment: Alignment.center,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Icon(FontAwesomeIcons.mobileScreenButton),
          ),
          Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(bottom: 2),
                child: const Icon(
                  FontAwesomeIcons.arrowRight,
                  size: 10,
                ),
              )),
        ],
      );
      reverse = false;
    } else if (reverse == false) {
      icon = Stack(
        alignment: Alignment.center,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Icon(FontAwesomeIcons.mobileScreenButton),
          ),
          Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(bottom: 2),
                child: const Icon(
                  FontAwesomeIcons.arrowLeft,
                  size: 10,
                ),
              )),
        ],
      );
      reverse = true;
    } else {
      axis = Axis.vertical;
      icon = Stack(
        alignment: Alignment.center,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Icon(FontAwesomeIcons.mobileScreenButton),
          ),
          Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(bottom: 2),
                child: const Icon(
                  FontAwesomeIcons.arrowDown,
                  size: 10,
                ),
              )),
        ],
      );
      reverse = false;
    }
    return (axis, icon, reverse);
  }

  static List<PhotoViewGalleryPageOptions> buildPages({
    required List<Chapter> chapters,
    required int chapterIndex,
    required List<String> imageUrls,
    required Function(BuildContext, TapUpDetails, PhotoViewControllerValue)? onTapUp,
  }) {
    List<PhotoViewGalleryPageOptions> pages = [
      PhotoViewGalleryPageOptions.customChild(
        onTapUp: onTapUp,
        child: PrevChapterPageWidget(
            chapters: chapters, chapterIndex: chapterIndex, nativeAd1: loadAd()),
      )
    ];
    for (var imageUrl in imageUrls) {
      final image = CachedNetworkImageProvider(imageUrl);
      pages.add(
        PhotoViewGalleryPageOptions(
          imageProvider: image,
          minScale: PhotoViewComputedScale.contained,
          tightMode: false,
          onTapUp: onTapUp,
        ),
      );
    }
    pages.add(
      PhotoViewGalleryPageOptions.customChild(
        onTapUp: onTapUp,
        child: NextChapterPageWidget(
            chapters: chapters, chapterIndex: chapterIndex, nativeAd2: loadAd()),
      ),
    );
    return pages;
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
