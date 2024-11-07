import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/entities/chapter.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/entities/manga.dart';

class ReaderBottomBar extends StatelessWidget {
  final bool reverse;
  final List<Chapter> chapters;
  final Manga manga;
  final int chapterIndex;
  final Axis axis;
  final Widget icon;
  final Slider slider;
  final List<String> images;
  final int pageIndex;
  final Function() onScope;
  final Function(int page, int chapterIndex) onPageChange;

  const ReaderBottomBar({
    required this.reverse,
    required this.chapters,
    required this.chapterIndex,
    required this.axis,
    required this.icon,
    required this.onScope,
    required this.images,
    required this.pageIndex,
    required this.onPageChange,
    required this.slider,
    required this.manga,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton.filled(
          icon: const Icon(FontAwesomeIcons.backwardStep),
          style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                fixedSize: const WidgetStatePropertyAll(Size(20, 20)),
              ),
          tooltip: !reverse ? "Previous chapter" : "Next chapter",
          onPressed: () {},
        ),
        Expanded(
          child: Directionality(
            textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
            child: Container(
              margin: const EdgeInsets.only(bottom: 1, left: 5, right: 5),
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xff2a2a2a),
                borderRadius: BorderRadius.circular(20),
              ),
              child: slider,
            ),
          ),
        ),
        IconButton.filled(
          onPressed: () {},
          tooltip: reverse ? "Previous chapter" : "Next chapter",
          icon: const Icon(FontAwesomeIcons.forwardStep),
          style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                fixedSize: const WidgetStatePropertyAll(Size(20, 20)),
              ),
        ),
      ],
    );
  }
}
