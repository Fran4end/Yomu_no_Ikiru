import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yomu_no_ikiru/constants.dart';
import 'package:yomu_no_ikiru/core/common/widgets/skeleton.dart';
import 'package:yomu_no_ikiru/core/utils/show_snackbar.dart';
import 'package:yomu_no_ikiru/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:yomu_no_ikiru/features/explore/presentation/widgets/manga_widget.dart';

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
    context.read<ExploreBloc>().add(
          ExploreFetchSearchList(
            maxPagesize: maxPagesize,
            source: "MangaWorld",
            filters: const {"page": 1},
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
        _resetSearch();
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
      body: BlocConsumer<ExploreBloc, ExploreState>(
        listener: (context, state) {
          if (state.status == ExploreStatus.failure) {
            showSnackBar(context, state.error ?? "Unexpected error occurred");
          }
        },
        builder: (context, state) {
          if (state.status == ExploreStatus.loading) {
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
                            _resetSearch();
                          },
                          icon: const Icon(Icons.clear_rounded)),
                    ),
                  ),
                ),
                Expanded(
                  child: MangaGrid(
                    tag: "explore",
                    mangaList: (context.read<ExploreBloc>().state).mangaList,
                    hasReachedMax: context.read<ExploreBloc>().state.hasReachedMax,
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

  _resetSearch() {
    context.read<ExploreBloc>().add(const ExploreResetList());
    context.read<ExploreBloc>().add(
          ExploreFetchSearchList(
            maxPagesize: maxPagesize,
            source: "MangaWorld",
            filters: const {'sort': 'most_read', "page": 1},
            query: textController.text.trim(),
          ),
        );
  }

  void _onScroll() {
    final hasReachedMax = context.read<ExploreBloc>().state.hasReachedMax;
    final isLoading = context.read<ExploreBloc>().state.status == ExploreStatus.loading;
    if (_isBottom && !hasReachedMax && !isLoading) {
      int page = context.read<ExploreBloc>().state.page;
      context.read<ExploreBloc>().add(
            ExploreFetchSearchList(
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
