import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/cubit/page_handler_cubit.dart';

/// Bottom navigation bar for the reader.
/// 
/// This widget is responsible for displaying the bottom navigation bar of the reader.
/// It contains the buttons to go to the next or previous chapter and the slider to navigate between the pages.
class ReaderBottomNavBar extends StatelessWidget {
  const ReaderBottomNavBar({
    super.key,
    required this.state,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
  });

  final ReaderSuccess state;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;

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
              child: BlocSelector<PageHandlerCubit, PageHandlerState, int>(
                selector: (state) {
                  return state.currentPage;
                },
                builder: (context, currentPage) {
                  return Slider.adaptive(
                    inactiveColor: Theme.of(context).colorScheme.secondary,
                    divisions: state.chapterSize - 1,
                    label: "$currentPage / ${state.chapterSize}",
                    min: 1,
                    max: state.chapterSize.toDouble(),
                    value: currentPage.toDouble(),
                    onChanged: onChanged,
                    onChangeStart: onChangeStart,
                    onChangeEnd: onChangeEnd,
                  );
                },
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
