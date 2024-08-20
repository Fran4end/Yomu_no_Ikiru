import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  String content, {
  Duration duration = const Duration(seconds: 2),
}) {
  final snackBar = SnackBar(
    margin: EdgeInsets.all(16).copyWith(bottom: 60),
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
              child: Flexible(
                child: Text(
                  content,
                ),
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
