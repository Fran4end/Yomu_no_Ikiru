import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yomu_no_ikiru/constants.dart';
import 'package:yomu_no_ikiru/core/common/widgets/loader.dart';
import 'package:yomu_no_ikiru/core/utils/show_snackbar.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/widgets/animated_bar.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/widgets/app_bar_reader_page.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/widgets/reader_bottom_nav_bar.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/widgets/reader_widget.dart';
import 'package:yomu_no_ikiru/init_dependencies.dart';

class Reader extends StatefulWidget {
  static route({
    required int chapterIndex,
    required Manga manga,
    required int pageIndex,
  }) =>
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => serviceLocator<ReaderBloc>(),
          child: Reader(
            chapterIndex: chapterIndex,
            manga: manga,
            pageIndex: pageIndex,
          ),
        ),
      );

  const Reader({
    super.key,
    required this.chapterIndex,
    required this.manga,
    required this.pageIndex,
  });

  final int chapterIndex, pageIndex;
  // final Function(int, int) onPageChange;
  final Manga manga;

  @override
  State<StatefulWidget> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  late final Manga manga = widget.manga;
  late int chapterIndex = widget.chapterIndex;
  // late final WebViewController controller;
  late final PageController pageController = PageController(
    initialPage: widget.pageIndex,
  );

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
    // _loadChapter(currentChap.link);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final readerBloc = context.read<ReaderBloc>();
    readerBloc.add(
      ReaderNewChapter(
        manga: manga,
        loadChapterIndex: chapterIndex,
      ),
    );
    return BlocConsumer<ReaderBloc, ReaderState>(
      listener: (context, state) {
        if (state is ReaderFailure) {
          showSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        if (state is! ReaderSuccess) {
          return const Loader();
        }
        if (pageController.hasClients && state.currentPage != pageController.page?.toInt()) {
          pageController.animateToPage(
            state.currentPage,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
          );
        }
        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AnimatedBar(
            begin: const Offset(0, -1),
            builder: () => !state.showAppBar
                ? const SizedBox.shrink()
                : ReaderAppBar(
                    state: state,
                    onPressed: () => readerBloc.add(ReaderChangeOrientation()),
                  ),
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: AnimatedBar(
                begin: const Offset(0, 1),
                builder: () => !state.showAppBar
                    ? const SizedBox.shrink()
                    : SafeArea(
                        child: ReaderBottomNavBar(
                          state: state,
                          onChanged: (value) {
                            readerBloc.add(
                              ReaderChangePage(
                                newPageIndex: value.toInt(),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () => readerBloc.add(ReaderShowAppBar(showAppBar: !state.showAppBar)),
            child: ReaderPageWidget(
              pageController: pageController,
            ),
          ),
        );
      },
    );
  }
}
