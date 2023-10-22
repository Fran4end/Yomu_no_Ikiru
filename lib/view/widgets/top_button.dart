import 'package:flutter/material.dart';

class TopButtonsFunctions extends StatelessWidget {
  const TopButtonsFunctions({
    Key? key,
    required this.ic,
    required this.function,
    required this.color,
  }) : super(key: key);

  final Icon ic;
  final Function()? function;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          ic.icon,
          size: 17,
        ),
      ),
    );
  }
}
