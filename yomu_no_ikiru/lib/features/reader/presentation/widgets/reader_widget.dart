import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/cubit/page_handler_cubit.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/widgets/separator_chapter_page_widget.dart';

/// Widget that displays the pages of the manga.
///
/// This widget is responsible for displaying the pages of the manga and the separator pages [SeparatorChapterPageWidget].
/// It handles the gestures of the user and the page changes.
class ReaderPageWidget extends StatelessWidget {
  final PageController pageController;

  const ReaderPageWidget({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final readerBloc = context.read<ReaderBloc>();
    final readerBlocState = readerBloc.state as ReaderSuccess;
    final orientation = readerBlocState.orientation;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          BlocSelector<PageHandlerCubit, PageHandlerState, bool>(
            selector: (state) => state.isSliding,
            builder: (context, isSliding) {
              context.read<PageHandlerCubit>().updateTotalPages(readerBlocState.chapterSize);
              return PhotoViewGallery(
                pageController: pageController,
                scrollDirection: orientation.axis,
                reverse: orientation.reverse,
                onPageChanged: (index) {
                  if (!isSliding) {
                    context.read<PageHandlerCubit>().updateCurrentPage(index.toInt());
                  }
                },
                gaplessPlayback: true,
                pageOptions: _buildPages(readerBlocState, readerBloc),
              );
            },
          ),
          orientation.changePageButtons,
        ],
      ),
    );
  }

  List<PhotoViewGalleryPageOptions> _buildPages(
    ReaderSuccess readerBlocState,
    ReaderBloc readerBloc,
  ) {
    final List<String> pages = readerBlocState.pages;
    if (pageController.hasClients) {
      prefetchImages(pages, pageController);
    }
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
