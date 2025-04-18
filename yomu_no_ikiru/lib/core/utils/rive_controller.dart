import 'package:rive/rive.dart';

StateMachineController getRiveController(Artboard artboard, {required stateMachineName}) {
  StateMachineController? controller;
  controller = StateMachineController.fromArtboard(artboard, stateMachineName);
  if (controller != null) {
    artboard.addController(controller);
    return controller;
  } else {
    return StateMachineController(StateMachine());
  }
}
