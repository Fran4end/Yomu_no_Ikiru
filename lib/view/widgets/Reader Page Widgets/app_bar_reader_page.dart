import 'package:flutter/material.dart';
import '../../../model/chapter.dart';

class ReaderPageAppBar extends StatelessWidget {
  final Chapter chapter;
  final Function() onPressed;
  final String mangaTitle;
  final Widget icon;

  const ReaderPageAppBar({
    super.key,
    required this.chapter,
    required this.onPressed,
    required this.mangaTitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        chapter.title.replaceAll(mangaTitle, ''),
        style: const TextStyle(fontSize: 14),
      ),
      actions: [
        Tooltip(
          message: "Reader direction",
          child: ElevatedButton.icon(
            label: const Text('Reader direction'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, elevation: 0),
            icon: icon,
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}