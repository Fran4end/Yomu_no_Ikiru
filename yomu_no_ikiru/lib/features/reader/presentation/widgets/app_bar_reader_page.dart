import 'package:flutter/material.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/bloc/reader_bloc.dart';

class ReaderAppBar extends StatelessWidget {
  final void Function()? onPressed;
  final ReaderSuccess state;

  const ReaderAppBar({
    super.key,
    required this.state,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final chapterTitle = state.manga.chapters[state.currentChapter].title;
    return AppBar(
      title: Text(
        chapterTitle.replaceAll(state.manga.title, ''),
        style: const TextStyle(fontSize: 14),
      ),
      actions: [
        Tooltip(
          message: "Reader direction",
          child: ElevatedButton.icon(
            label: const Text('Reader direction'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, elevation: 0),
            icon: state.orientation.icon,
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}
