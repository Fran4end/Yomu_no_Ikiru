import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../constants.dart';
import '../../../model/chapter.dart';

class PrevChapterPageWidget extends StatelessWidget {
  const PrevChapterPageWidget({
    super.key,
    required this.chapters,
    required this.chapterIndex,
    required this.nativeAd1,
  });

  final List<Chapter> chapters;
  final int chapterIndex;
  final NativeAd nativeAd1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: chapterIndex + 1 >= chapters.length
          ? Text(
              " ${chapters[chapterIndex].title}\n\nNo more chapters available",
              textAlign: TextAlign.center,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: defaultPadding * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Current: ", style: TextStyle(fontWeight: FontWeight.bold)),
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
                      const Text("Previous: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(chapters[chapterIndex + 1].title),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
