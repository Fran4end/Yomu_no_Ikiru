import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text) {
    if (text == null) return;
    final snackBar = SnackBar(content: Text(text));

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