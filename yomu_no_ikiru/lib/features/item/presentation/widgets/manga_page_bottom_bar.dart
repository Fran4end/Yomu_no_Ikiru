import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Widget that displays the bottom bar for the manga page.
///
/// This widget is a [Row] that displays a back button and a resume button.
/// The arrow down button is used to navigate down to the first chapter of the manga.
/// The resume button is used to resume reading the manga from where the user left off.
class MangaPageBottomBar extends StatelessWidget {
  const MangaPageBottomBar({super.key, required this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 30,
          width: 30,
          child: Opacity(
            opacity: .7,
            child: IconButton.outlined(
                padding: const EdgeInsets.all(0.0),
                iconSize: 20,
                onPressed: onPressed,
                icon: const Icon(FontAwesomeIcons.arrowDown)),
          ),
        ),
        SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.play, size: 20, color: Color(0xff0D0D0D)),
            label: const Center(
              child: Text('Resume', style: TextStyle(color: Color(0xff0D0D0D))),
            ),
          ),
        ),
      ],
    );
  }
}
