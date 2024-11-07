import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yomu_no_ikiru/constants.dart';
import 'package:yomu_no_ikiru/core/common/widgets/skeleton.dart';
import 'package:yomu_no_ikiru/core/utils/show_snackbar.dart';
import 'package:yomu_no_ikiru/features/manga/common/presentation/bloc/manga_bloc.dart';
import 'package:yomu_no_ikiru/features/manga/explore/presentation/widgets/manga_widget.dart';

class ExplorePage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const ExplorePage(),
      );
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final textController = TextEditingController();
  final _scrollController = ScrollController();
  final maxPagesize = 16;

  @override
  void initState() {
    context.read<MangaBloc>().add(
          MangaFetchSearchList(
            maxPagesize: maxPagesize,
            source: "MangaWorld",
            filters: const {'sort': 'most_read', "page": 1},
            query: "",
          ),
        );
    _scrollController.addListener(_onScroll);
    super.initState();
    _addTextListener();
  }

  _addTextListener() {
    textController.addListener(
      () {
        context.read<MangaBloc>().add(const MangaResetList());
        context.read<MangaBloc>().add(
              MangaFetchSearchList(
                maxPagesize: maxPagesize,
                source: "MangaWorld",
                filters: const {'sort': 'most_read', "page": 1},
                query: textController.text.trim(),
              ),
            );
      },
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Explore',
        ),
      ),
      body: BlocConsumer<MangaBloc, MangaState>(
        listener: (context, state) {
          if (state.status == MangaStatus.failure) {
            showSnackBar(context, state.error ?? "Unexpected error occurred");
          }
        },
        builder: (context, state) {
          if (state.status == MangaStatus.loading && state.mangaList == null) {
            return const SkeletonGrid();
          }
          return RefreshIndicator(
            onRefresh: () => Future.delayed(const Duration(milliseconds: 500), () {}),
            child: Column(
              children: [
                Container(
                  height: 50,
                  margin: const EdgeInsets.all(defaultPadding),
                  child: TextField(
                    controller: textController,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      labelText: "Search",
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                          onPressed: () {
                            textController.clear();
                            context.read<MangaBloc>().add(const MangaResetList());
                            context.read<MangaBloc>().add(
                                  MangaFetchSearchList(
                                    maxPagesize: maxPagesize,
                                    source: "MangaWorld",
                                    filters: const {'sort': 'most_read', "page": 1},
                                  ),
                                );
                          },
                          icon: const Icon(Icons.clear_rounded)),
                    ),
                  ),
                ),
                Expanded(
                  child: MangaGrid(
                    tag: "explore",
                    mangaList: (context.read<MangaBloc>().state).mangaList ?? [],
                    hasReachedMax: context.read<MangaBloc>().state.hasReachedMax,
                    scrollController: _scrollController,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onScroll() {
    final hasReachedMax = context.read<MangaBloc>().state.hasReachedMax;
    final isLoading = context.read<MangaBloc>().state.status == MangaStatus.loading;
    if (_isBottom && !hasReachedMax && !isLoading) {
      int page = context.read<MangaBloc>().state.page;
      context.read<MangaBloc>().add(
            MangaFetchSearchList(
              maxPagesize: maxPagesize,
              source: "MangaWorld",
              filters: {'sort': 'most_read', "page": ++page},
              query: textController.text.trim(),
            ),
          );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * .7);
  }
}
