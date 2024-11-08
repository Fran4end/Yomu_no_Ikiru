import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:yomu_no_ikiru/features/manga/reader/presentation/bloc/reader_bloc.dart';
import 'package:yomu_no_ikiru/features/manga/reader/presentation/bloc/reader_orientation.dart';
import 'package:yomu_no_ikiru/features/manga/reader/presentation/widgets/separator_chapter_page_widget.dart';

class ReaderPageWidget extends StatelessWidget {
  final ReaderOrientationType orientation;
  final PageController pageController;

  const ReaderPageWidget({
    super.key,
    required this.orientation,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final readerBloc = context.read<ReaderBloc>();
    final readerBlocState = readerBloc.state as ReaderSuccess;
    return Listener(
      onPointerSignal: (event) {
        onPointerSignal(event, pageController);
      },
      child: PhotoViewGallery(
        pageController: pageController,
        scrollDirection: orientation.axis,
        reverse: orientation.reverse,
        gaplessPlayback: true,
        onPageChanged: (index) {
          // readerBloc.add(ReaderChangePage(newPageIndex: index, isSliding: false));
        },
        pageOptions: _buildPages(readerBlocState, readerBloc),
      ),
    );
  }

  List<PhotoViewGalleryPageOptions> _buildPages(
    ReaderSuccess readerBlocState,
    ReaderBloc readerBloc,
  ) {
    return List.generate(
      readerBlocState.chapterSize + 2,
      (index) {
        if (index == 0) {
          return _setPrevSeparatorPage(readerBloc);
        } else if (index == readerBlocState.chapterSize + 1) {
          return _setNextSeparatorPage(readerBloc);
        }
        return PhotoViewGalleryPageOptions(
          imageProvider: CachedNetworkImageProvider(readerBlocState.pages[index - 1]),
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
        );
      },
    );
  }

  _setPrevSeparatorPage(ReaderBloc readerBloc) {
    final readerBlocState = readerBloc.state as ReaderSuccess;
    return PhotoViewGalleryPageOptions.customChild(
      child: readerBloc.hasReachedMin
          ? NullSeparatorChapterPageWidget(
              currentChapter: readerBlocState.manga.chapters[readerBlocState.currentChapter],
            )
          : SeparatorChapterPageWidget(
              nextChapter: readerBlocState.manga.chapters[readerBlocState.currentChapter - 1],
              currentChapter: readerBlocState.manga.chapters[readerBlocState.currentChapter],
              isNext: false,
            ),
    );
  }

  _setNextSeparatorPage(ReaderBloc readerBloc) {
    final readerBlocState = readerBloc.state as ReaderSuccess;
    return PhotoViewGalleryPageOptions.customChild(
      child: readerBloc.hasReachedMax
          ? NullSeparatorChapterPageWidget(
              currentChapter: readerBlocState.manga.chapters[readerBlocState.currentChapter],
            )
          : SeparatorChapterPageWidget(
              nextChapter: readerBlocState.manga.chapters[readerBlocState.currentChapter + 1],
              currentChapter: readerBlocState.manga.chapters[readerBlocState.currentChapter],
              isNext: true,
            ),
    );
  }
}
