import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../model/manga.dart';

class GenresWrap extends StatelessWidget {
  const GenresWrap({
    Key? key,
    required this.manga,
  }) : super(key: key);

  final Manga manga;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
      child: Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        children: manga.genres.map((e) {
          return Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding / 2),
                child: Text(e),
              ));
        }).toList(),
      ),
    );
  }
}
