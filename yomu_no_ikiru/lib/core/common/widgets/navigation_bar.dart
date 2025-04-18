import 'package:flutter/material.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:rive/rive.dart';
import 'package:yomu_no_ikiru/core/utils/constants.dart';
import 'package:yomu_no_ikiru/core/utils/navigation_bar_destination.dart';
import 'package:yomu_no_ikiru/core/utils/rive_controller.dart';
import 'package:yomu_no_ikiru/features/explore/presentation/page/explore_page.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({super.key});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int _selectedIndex = 0;

  NavigationBarDestination _selectedDestination = navigationBarDestinations.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: NavigationBarTheme(
          data: Theme.of(context).navigationBarTheme,
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            height: 60,
            animationDuration: const Duration(milliseconds: 400),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            onDestinationSelected: (index) {
              // Unselect the old destination with reverse animation
              final SMIBool oldSelected = _selectedDestination.controller.findSMI("active");
              oldSelected.change(false);

              // Select the new destination
              _selectedIndex = index;
              _selectedDestination = navigationBarDestinations[index];

              //start the animation for the new destination
              final SMIBool newSelected = _selectedDestination.controller.findSMI("active");
              newSelected.change(true);

              // Set the initial state of the animation to false for the new destination if is not already set
              final SMIBool init = _selectedDestination.controller.findSMI("init");
              if (init.value) {
                init.change(false);
              }

              setState(() {});
            },
            destinations: [
              ...List.generate(
                navigationBarDestinations.length,
                (index) => NavigationDestinationWidget(
                  index: index,
                  selectedDestination: _selectedDestination,
                ),
              )
            ],
          ),
        ),
      ),
      body: LazyLoadIndexedStack(
        index: _selectedIndex,
        children: const [
          ExplorePage(),
          Center(child: Text('Library')),
          Center(child: Text('Profile')),
        ],
      ),
    );
  }
}

class NavigationDestinationWidget extends StatelessWidget {
  final int index;
  final NavigationBarDestination selectedDestination;

  const NavigationDestinationWidget({
    super.key,
    required this.index,
    required this.selectedDestination,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      label: navigationBarDestinations[index].label,
      icon: SizedBox(
        height: 26,
        width: 26,
        child: Opacity(
          opacity: navigationBarDestinations[index] == selectedDestination ? 1 : 0.5,
          child: RiveAnimation.asset(
            navigationBarDestinations[index].iconPath,
            artboard: navigationBarDestinations[index].artboard,
            onInit: (artboard) {
              StateMachineController controller = getRiveController(
                artboard,
                stateMachineName: navigationBarDestinations[index].stateMachineName,
              );
              navigationBarDestinations[index].controller = controller;

              // Set the initial state of the animation
              if (navigationBarDestinations[index] != navigationBarDestinations.first) {
                // for all destinations except the first one
                navigationBarDestinations[index].controller.findSMI("active")?.change(false);
                navigationBarDestinations[index].controller.findSMI("init")?.change(true);
              } else {
                // for the first destination
                navigationBarDestinations[index].controller.findSMI("active")?.change(true);
                navigationBarDestinations[index].controller.findSMI("init")?.change(false);
              }
            },
          ),
        ),
      ),
    );
  }
}
