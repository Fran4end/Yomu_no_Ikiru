import 'package:flutter/widgets.dart';
import 'package:yomu_no_ikiru/constants.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/entities/chapter.dart';

class SeparatorChapterPageWidget extends StatelessWidget {
  const SeparatorChapterPageWidget({
    super.key,
    required this.nextChapter,
    required this.currentChapter,
    this.isNext = true,
  });

  final Chapter nextChapter;
  final Chapter currentChapter;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final String text = isNext ? "Next:" : "Previous:";
    final crossAxisAlignment = isNext ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final mainAxisAlignment = isNext ? MainAxisAlignment.start : MainAxisAlignment.end;
    return Padding(
      padding: const EdgeInsets.all(defaultPadding * 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: [
              const Text("Current: \n", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${currentChapter.title} "),
            ],
          ),
          // ConstrainedBox(
          //   constraints: const BoxConstraints(
          //     minWidth: 320, // minimum recommended width
          //     minHeight: 320, // minimum recommended height
          //     maxWidth: 400,
          //     maxHeight: 400,
          //   ),
          //   child: Container(),
          // ),
          Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: [
              Text("$text \n", style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(nextChapter.title),
            ],
          ),
        ],
      ),
    );
  }
}

class NullSeparatorChapterPageWidget extends StatelessWidget {
  const NullSeparatorChapterPageWidget({super.key, required this.currentChapter});
  final Chapter currentChapter;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        " ${currentChapter.title}\n\nNo more chapters available",
        textAlign: TextAlign.center,
      ),
    );
  }
}
