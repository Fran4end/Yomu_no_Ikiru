import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:yomu_no_ikiru/constants.dart';

import '../../../model/chapter.dart';

class ReaderPageWidget extends StatelessWidget {
  final Axis axis;
  final bool reverse;
  final List<String> imageUrls;
  final PageController? pageController;
  final List<Chapter> chapters;
  final int chapterIndex;
  final NativeAd nativeAd1;
  final NativeAd nativeAd2;
  final Function(BuildContext, TapUpDetails, PhotoViewControllerValue) onTapUp;
  final Function(int) onPageChanged;

  const ReaderPageWidget({
    super.key,
    required this.axis,
    required this.reverse,
    required this.imageUrls,
    required this.pageController,
    required this.chapters,
    required this.chapterIndex,
    required this.nativeAd1,
    required this.onTapUp,
    required this.onPageChanged,
    required this.nativeAd2,
  });

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      pageController: pageController,
      itemCount: imageUrls.length + 2,
      scrollDirection: axis,
      reverse: reverse,
      onPageChanged: onPageChanged,
      builder: (context, index) {
        if (index == 0) {
          return PhotoViewGalleryPageOptions.customChild(
            onTapUp: onTapUp,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding * 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Current:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(" ${chapters[chapterIndex].title} "),
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 320, // minimum recommended width
                      minHeight: 320, // minimum recommended height
                      maxWidth: 400,
                      maxHeight: 400,
                    ),
                    child: AdWidget(ad: nativeAd1),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: defaultPadding * 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Previous:", style: TextStyle(fontWeight: FontWeight.bold)),
                        chapterIndex + 1 < chapters.length
                            ? Text(" ${chapters[chapterIndex + 1].title} ")
                            : const Text(" No more chapter "),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (index == imageUrls.length + 1) {
          return PhotoViewGalleryPageOptions.customChild(
            onTapUp: onTapUp,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding * 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Current:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(" ${chapters[chapterIndex].title} "),
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 320, // minimum recommended width
                      minHeight: 320, // minimum recommended height
                      maxWidth: 400,
                      maxHeight: 400,
                    ),
                    child: AdWidget(ad: nativeAd2),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: defaultPadding * 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Next:", style: TextStyle(fontWeight: FontWeight.bold)),
                        chapterIndex - 1 >= 0
                            ? Text(" ${chapters[chapterIndex - 1].title} ")
                            : const Text(" No more chapter "),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          final image = CachedNetworkImageProvider(imageUrls[index - 1]);
          return PhotoViewGalleryPageOptions(
            imageProvider: image,
            minScale: PhotoViewComputedScale.contained,
            tightMode: false,
            onTapUp: onTapUp,
          );
        }
      },
    );
  }
}
