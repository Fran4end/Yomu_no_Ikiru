import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:yomu_no_ikiru/constants.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text) {
    if (text == null) return;
    final snackBar = SnackBar(
      margin: const EdgeInsets.all(defaultPadding),
      backgroundColor: darkTheme.snackBarTheme.backgroundColor!.withOpacity(0.9),
      duration: const Duration(seconds: 1),
      content: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: defaultPadding),
            child: Image.asset(
              "assets/icon.png",
              fit: BoxFit.cover,
              height: 50,
            ),
          ),
          AutoSizeText(
            text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static StateMachineController getRiveController(Artboard artboard, {required stateMachineName}) {
    StateMachineController? controller;
    controller = StateMachineController.fromArtboard(artboard, stateMachineName);
    if (controller != null) {
      artboard.addController(controller);
      return controller;
    } else {
      return StateMachineController(StateMachine());
    }
  }
}
