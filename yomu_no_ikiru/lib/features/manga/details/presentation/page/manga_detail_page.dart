import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yomu_no_ikiru/constants.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/entities/manga.dart';
import 'package:yomu_no_ikiru/features/manga/common/presentation/bloc/manga_bloc.dart';
import 'package:yomu_no_ikiru/features/manga/details/presentation/widgets/manga_page_app_bar.dart';
import 'package:yomu_no_ikiru/features/manga/details/presentation/widgets/manga_page_bottom_bar.dart';
import 'package:yomu_no_ikiru/features/manga/details/presentation/widgets/manga_page_chapter_list.dart';
import 'package:yomu_no_ikiru/features/manga/details/presentation/widgets/manga_page_app_bar_detail.dart';

class MangaDetailPage extends StatefulWidget {
  static route({
    required String tag,
    required Manga manga,
  }) =>
      MaterialPageRoute(
        builder: (context) => MangaDetailPage(
          tag: tag,
          manga: manga,
        ),
      );

  const MangaDetailPage({
    super.key,
    required this.tag,
    required this.manga,
  });

  final String tag;
  final Manga manga;

  @override
  State<StatefulWidget> createState() => _MangaDetailPageState();
}

class _MangaDetailPageState extends State<MangaDetailPage> {
  late Manga manga = widget.manga;
  bool save = false;
  final scrollController = ScrollController();
  bool isOnLibrary = false;
  late MangaBloc mangaBloc = context.read<MangaBloc>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mangaBloc = context.read<MangaBloc>();
  }

  @override
  void initState() {
    super.initState();
    context.read<MangaBloc>().add(
          MangaFetchDetails(
            id: manga.id,
            link: manga.link,
            title: manga.title,
            artist: manga.artist,
            author: manga.author,
            coverUrl: manga.coverUrl,
            status: manga.status.name,
            source: manga.source,
          ),
        );
  }

  @override
  void dispose() {
    saveBookmark();
    scrollController.dispose();
    // mangaBloc.add(MangaDispose());
    super.dispose();
  }

  void saveBookmark() {
    if (save) {
      // save to library
    }
  }

  @override
  Widget build(BuildContext context) {
    //final user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => mangaBloc.add(
            MangaFetchDetails(
              id: manga.id,
              link: manga.link,
              title: manga.title,
              artist: manga.artist,
              author: manga.author,
              coverUrl: manga.coverUrl,
              status: manga.status.name,
              source: manga.source,
            ),
          ),
        ),
        child: BlocBuilder<MangaBloc, MangaState>(
          builder: (context, state) {
            if (state.status == MangaStatus.success &&
                state.manga != null &&
                state.manga!.title == manga.title) {
              manga = state.manga!;
            }
            return Stack(
              children: [
                CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    CustomSliverAppBar(
                      save: save,
                      rightButtonFunction: () {
                        //TODO: save to library
                      },
                      manga: manga,
                      tag: widget.tag,
                    ),
                    SliverToBoxAdapter(
                      child: MangaPlot(
                        manga: manga,
                      ),
                    ),
                    MangaPageChapterList(manga: manga),
                  ],
                ),
                manga.chapters.isNotEmpty
                    ? Positioned(
                        bottom: 25,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
                          child: MangaPageBottomBar(
                            onPressed: () {
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      )
                    : const Center(),
              ],
            );
          },
        ),
      ),
    );
  }
}
