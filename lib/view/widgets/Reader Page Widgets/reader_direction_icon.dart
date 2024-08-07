import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RightLeftIcon extends StatelessWidget {
  const RightLeftIcon({super.key});

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
                FontAwesomeIcons.arrowLeft,
                size: 7,
              ),
            )),
      ],
    );
  }
}

class LeftRightIcon extends StatelessWidget {
  const LeftRightIcon({super.key});

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
                FontAwesomeIcons.arrowRight,
                size: 7,
              ),
            )),
      ],
    );
  }
}

class TopDownIcon extends StatelessWidget {
  const TopDownIcon({super.key});

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