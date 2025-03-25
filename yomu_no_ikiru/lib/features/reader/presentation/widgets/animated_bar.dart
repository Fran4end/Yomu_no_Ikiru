import 'package:flutter/material.dart';

/// Animated bar that slides in from the given [begin] offset.
///
/// This widget is responsible for animation of app bar [ReaderAppBar] and bottom navigation bar [ReaderBottomNavBar].
class AnimatedBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget Function() builder;
  final Offset begin;
  final double height;

  const AnimatedBar({
    super.key,
    required this.builder,
    required this.begin,
    this.height = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: begin,
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      duration: const Duration(milliseconds: 250),
      child: builder(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
