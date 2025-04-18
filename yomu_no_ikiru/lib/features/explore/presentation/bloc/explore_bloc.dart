import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yomu_no_ikiru/core/utils/constants.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';
import 'package:yomu_no_ikiru/features/explore/domain/usecase/search_manga.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final SearchMangaList _getMangaList;

  ExploreBloc({
    required SearchMangaList getMangaList,
  })  : _getMangaList = getMangaList,
        super(ExploreState()) {
    on<ExploreEvent>((event, emit) {});
    on<ExploreFetchSearchList>(
      _onExploreFetchSearchList,
      transformer: throttleDroppable(throttleDuration),
    );
    on<ExploreResetList>(_onExploreResetList, transformer: throttleRestartable(throttleDuration));
  }

  void _onExploreResetList(ExploreResetList event, Emitter<ExploreState> emit) {
    emit(
      state.copyWith(
        mangaList: [],
        page: 1,
        hasReachedMax: false,
        status: ExploreStatus.initial,
      ),
    );
  }

  void _onExploreFetchSearchList(ExploreFetchSearchList event, Emitter<ExploreState> emit) async {
    final res = await _getMangaList(SearchMangaParams(
      source: event.source,
      query: event.query,
      filters: event.filters,
    ));
    res.fold(
      (l) => emit(state.copyWith(status: ExploreStatus.failure, error: l.message)),
      (list) {
        bool hasReachedMax = false;
        if (list.length < event.maxPagesize) {
          hasReachedMax = true;
        }
        final List<Manga> mangaList = state.mangaList;
        emit(
          state.copyWith(
            mangaList: [...mangaList, ...list],
            status: ExploreStatus.success,
            hasReachedMax: hasReachedMax,
            page: state.page + 1,
          ),
        );
      },
    );
  }
}
