import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  String content, {
  Duration duration = const Duration(seconds: 1),
}) {
  final snackBar = SnackBar(
    margin: const EdgeInsets.only(
      bottom: 60,
      left: 16,
      right: 16,
    ),
    behavior: SnackBarBehavior.floating,
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    duration: duration,
    content: Opacity(
      opacity: 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: Image.asset(
              "assets/icon.png",
              fit: BoxFit.cover,
              height: 20,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
