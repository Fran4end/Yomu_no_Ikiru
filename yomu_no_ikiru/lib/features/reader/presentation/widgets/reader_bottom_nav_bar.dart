import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/bloc/reader_bloc.dart';

class ReaderBottomNavBar extends StatelessWidget {
  const ReaderBottomNavBar({
    super.key,
    required this.state,
    required this.onChanged,
  });

  final ReaderSuccess state;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    final reverse = state.orientation.reverse;
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
              child: Slider.adaptive(
                inactiveColor: Theme.of(context).colorScheme.secondary,
                divisions: state.chapterSize - 1,
                label: "${state.currentPage.toInt()} / ${state.chapterSize}",
                min: 1,
                max: state.chapterSize.toDouble(),
                value: state.currentPage.toDouble(),
                onChanged: onChanged,
              ),
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
