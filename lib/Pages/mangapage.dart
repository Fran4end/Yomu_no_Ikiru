import 'package:flutter/material.dart';

class MangaPage extends StatelessWidget {
  const MangaPage({
    required this.title,
    super.key,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}
