import 'package:flutter/material.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/entities/manga.dart';

class GenresWrap extends StatelessWidget {
  const GenresWrap({
    super.key,
    required this.manga,
  });

  final Manga manga;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      direction: Axis.horizontal,
      runAlignment: WrapAlignment.center,
      children: manga.genres.map((e) {
        return Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(e, style: const TextStyle(fontSize: 12)),
            ));
      }).toList(),
    );
  }
}
