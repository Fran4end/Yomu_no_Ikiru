import 'package:rive/rive.dart';

class NavigationBarDestination {
  final String label;
  final String artboard;
  final String stateMachineName;
  final String iconPath;
  final String routeName;
  late StateMachineController controller;
  // late SMIBool isSelected;

  NavigationBarDestination({
    required this.label,
    required this.iconPath,
    required this.routeName,
    required this.artboard,
    required this.stateMachineName,
  });
}
