import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
