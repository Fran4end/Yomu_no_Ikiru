import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Icon that represents the vertical orientation.
/// 
/// This icon is used to indicate the vertical reading mode in the reader interface.
class VerticalIcon extends StatelessWidget {
  const VerticalIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Align(
          alignment: Alignment.center,
          child: Icon(FontAwesomeIcons.mobileScreenButton),
        ),
        Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(bottom: 2),
              child: const Icon(
                FontAwesomeIcons.arrowDown,
                size: 10,
              ),
            )),
      ],
    );
  }
}
