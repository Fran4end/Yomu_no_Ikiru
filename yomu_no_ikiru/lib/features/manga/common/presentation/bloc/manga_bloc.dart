import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yomu_no_ikiru/constants.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/entities/manga.dart';
import 'package:yomu_no_ikiru/features/manga/details/domain/usecase/get_manga_details.dart';
import 'package:yomu_no_ikiru/features/manga/explore/domain/usecase/search_manga.dart';

part 'manga_event.dart';
part 'manga_state.dart';

class MangaBloc extends Bloc<MangaEvent, MangaState> {
  final GetMangaDetails _getMangaDetails;
  final SearchMangaList _getMangaList;
  MangaBloc({
    required GetMangaDetails getMangaDetails,
    required SearchMangaList getMangaList,
  })  : _getMangaDetails = getMangaDetails,
        _getMangaList = getMangaList,
        super(const MangaState()) {
    on<MangaEvent>((_, emit) => emit(state.copyWith(status: MangaStatus.loading, error: null)));
    on<MangaFetchSearchList>(_onMangaFetchSearchList,
        transformer: throttleDroppable(throttleDuration));
    on<MangaFetchDetails>(_onMangaFetchDetails, transformer: throttleRestartable(throttleDuration));
    on<MangaResetList>(_onMangaResetList, transformer: throttleRestartable(throttleDuration));
    on<MangaDispose>((event, emit) => emit(state.copyWith(manga: null)));
  }

  void _onMangaResetList(MangaResetList event, Emitter<MangaState> emit) {
    emit(state.copyWith(mangaList: [], page: 1, hasReachedMax: false));
  }

  void _onMangaFetchSearchList(MangaFetchSearchList event, Emitter<MangaState> emit) async {
    final res = await _getMangaList(SearchMangaParams(
      source: event.source,
      query: event.query,
      filters: event.filters,
    ));
    res.fold(
      (l) => emit(state.copyWith(status: MangaStatus.failure, error: l.message)),
      (list) {
        bool hasReachedMax = false;
        if (list.length < event.maxPagesize) {
          hasReachedMax = true;
        }
        final List<Manga> mangaList = state.mangaList ?? [];
        emit(
          state.copyWith(
            mangaList: [...mangaList, ...list],
            status: MangaStatus.success,
            hasReachedMax: hasReachedMax,
            page: state.page + 1,
          ),
        );
      },
    );
  }

  void _onMangaFetchDetails(MangaFetchDetails event, Emitter<MangaState> emit) async {
    final res = await _getMangaDetails(
      MangaDetailParams(
        id: event.id,
        link: event.link,
        title: event.title,
        artist: event.artist,
        author: event.author,
        coverUrl: event.coverUrl,
        status: event.status,
        source: event.source,
      ),
    );
    res.fold(
      (l) => emit(state.copyWith(status: MangaStatus.failure, error: l.message)),
      (manga) => emit(
        state.copyWith(
          manga: manga,
          status: MangaStatus.success,
        ),
      ),
    );
  }
}
