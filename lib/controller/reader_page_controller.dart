import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Api/adapter.dart';
import '../constants.dart';
import '../model/manga_builder.dart';
import '../view/Pages/reader_page.dart';

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
                  lastPage: true,
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

  static pageControllerListener({
    required List<String> imageUrls,
    required PageController pageController,
    required BuildContext context,
    required MangaBuilder builder,
    required int chapterIndex,
    required Axis axis,
    required Widget icon,
    required bool reverse,
    required MangaApiAdapter api,
    required Function(MangaBuilder) onScope,
    required Function(int page, int chapterIndex) onPageChange,
    required WebViewController controller,
  }) {
    onPageChange(pageController.page!.toInt(), (builder.chapters.length - chapterIndex) - 1);
    if (imageUrls.isNotEmpty) {
      if (pageController.page == imageUrls.length + 1 && chapterIndex - 1 >= 0) {
        // ReaderPageController.nextChapter(
        //   context: context,
        //   builder: builder,
        //   chapterIndex: chapterIndex,
        //   axis: axis,
        //   icon: icon,
        //   reverse: reverse,
        //   onScope: onScope,
        //   onPageChange: onPageChange,
        //   api: api,
        // );
      } else if (pageController.page == 0 && chapterIndex + 1 < builder.chapters.length) {
        // ReaderPageController.previousChapter(
        //   context: context,
        //   builder: builder,
        //   chapterIndex: chapterIndex,
        //   axis: axis,
        //   icon: icon,
        //   reverse: reverse,
        //   onScope: onScope,
        //   onPageChange: onPageChange,
        //   api: api,
        // );
      }
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
    final configuration = createLocalImageConfiguration(context);
    CachedNetworkImageProvider(path).resolve(configuration);
  }
}
