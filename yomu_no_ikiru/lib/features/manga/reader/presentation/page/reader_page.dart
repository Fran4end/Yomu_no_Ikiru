import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yomu_no_ikiru/core/common/widgets/loader.dart';
import 'package:yomu_no_ikiru/core/utils/show_snackbar.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/entities/manga.dart';
import 'package:yomu_no_ikiru/features/manga/reader/presentation/bloc/reader_bloc.dart';
import 'package:yomu_no_ikiru/features/manga/reader/presentation/widgets/reader_widget.dart';
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

  bool isSliding = false;
  double sliderValue = 2;

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
        if (state is ReaderLoading || state is ReaderInitial) {
          return const Loader();
        }
        return Scaffold(
          body: GestureDetector(
            onTap: () => readerBloc.add(ReaderShowAppBar()),
            child: ReaderPageWidget(
              axis: Axis.horizontal,
              reverse: true,
              pageController: pageController,
            ),
          ),
        );
      },
    );
  }
}
