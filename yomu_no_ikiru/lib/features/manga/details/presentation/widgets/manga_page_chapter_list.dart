import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/entities/manga.dart';
import 'package:yomu_no_ikiru/features/manga/reader/presentation/page/reader_page.dart';

class MangaPageChapterList extends StatelessWidget {
  const MangaPageChapterList({super.key, required this.manga});

  final Manga manga;

  @override
  Widget build(BuildContext context) {
    final chapters = manga.chapters.reversed.toList();
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 90),
      sliver: SliverFixedExtentList(
        itemExtent: 80,
        delegate: SliverChildBuilderDelegate(
          childCount: chapters.length,
          (context, index) {
            return Card(
              elevation: 5,
              child: ListTile(
                title: Text(
                  chapters[index].title,
                ),
                subtitle: Text(
                  DateFormat("dd/MM/yy").format(chapters[index].date),
                ),
                onTap: () => Navigator.of(context).push(
                  Reader.route(
                    chapterIndex: (chapters.length - 1) - index,
                    manga: manga,
                    pageIndex: 0,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
