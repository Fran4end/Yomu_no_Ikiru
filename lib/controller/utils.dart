import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:yomu_no_ikiru/constants.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text, {Duration duration = const Duration(seconds: 1)}) {
    if (text == null) return;
    final snackBar = SnackBar(
      margin: const EdgeInsets.all(defaultPadding * 4),
      backgroundColor: darkTheme.snackBarTheme.backgroundColor!.withOpacity(0.5),
      duration: duration,
      content: Opacity(
        opacity: .5,
        child: SizedBox(
          height: 30,
          width: 50,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(right: defaultPadding / 2),
                child: Image.asset(
                  "assets/icon.png",
                  fit: BoxFit.cover,
                  height: 20,
                ),
              ),
              Expanded(
                child: AutoSizeText(
                  text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
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
