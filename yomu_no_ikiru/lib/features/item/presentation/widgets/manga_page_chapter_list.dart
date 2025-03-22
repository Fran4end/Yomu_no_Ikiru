import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/page/reader_page.dart';

/// Widget that displays the list of chapters for the manga.
///
/// This widget is a [SliverFixedExtentList] that displays the chapters of the manga.
/// Each chapter is displayed as a [Card] with a [ListTile] that displays the chapter's title and date.
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
                    pageIndex: 1,
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
