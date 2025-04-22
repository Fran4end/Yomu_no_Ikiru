import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yomu_no_ikiru/core/utils/constants.dart';
import 'package:yomu_no_ikiru/core/common/cubits/currentmanga/current_manga_cubit.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';
import 'package:yomu_no_ikiru/core/common/widgets/loader.dart';
import 'package:yomu_no_ikiru/features/item/presentation/bloc/details_bloc.dart';
import 'package:yomu_no_ikiru/features/item/presentation/widgets/manga_page_app_bar.dart';
import 'package:yomu_no_ikiru/features/item/presentation/widgets/manga_page_bottom_bar.dart';
import 'package:yomu_no_ikiru/features/item/presentation/widgets/manga_page_chapter_list.dart';
import 'package:yomu_no_ikiru/features/item/presentation/widgets/manga_page_app_bar_detail.dart';
import 'package:yomu_no_ikiru/init_dependencies.dart';

class MangaDetailPage extends StatefulWidget {
  static route({
    required String tag,
    required Manga manga,
  }) =>
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => serviceLocator<DetailsBloc>(),
          child: MangaDetailPage(
            tag: tag,
            manga: manga,
          ),
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

  @override
  void dispose() {
    saveBookmark();
    scrollController.dispose();
    // detailsBloc.add(MangaDispose());
    super.dispose();
  }

  void saveBookmark() {
    if (save) {
      // save to library
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailsBloc = context.read<DetailsBloc>();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => detailsBloc.add(
            DetailsFetch(
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
        child: BlocBuilder<DetailsBloc, DetailsState>(
          builder: (context, state) {
            if (_mangaAlreadyLoaded) {
              detailsBloc.add(
                DetailsAlreadyLoaded(
                    (context.read<CurrentMangaCubit>().state as CurrentMangaLoaded).manga),
              );
            } else {
              detailsBloc.add(
                DetailsFetch(
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
            if (state is DetailsSuccess) {
              manga = state.manga;
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
                    (state is DetailsLoading)
                        ? const SliverToBoxAdapter(
                            child: Loader(),
                          )
                        : MangaPageChapterList(manga: manga),
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

  bool get _mangaAlreadyLoaded =>
      context.read<CurrentMangaCubit>().state is CurrentMangaLoaded &&
      (context.read<CurrentMangaCubit>().state as CurrentMangaLoaded).manga.title == manga.title;
}
