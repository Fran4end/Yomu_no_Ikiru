import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';
import 'package:yomu_no_ikiru/features/reader/domain/usecase/get_current_chapter.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/bloc/reader_orientation.dart';

part 'reader_event.dart';
part 'reader_state.dart';
part 'reader_utils.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  final GetChapter _getCurrentChapter;

  ReaderBloc({
    required GetChapter getCurrentChapter,
  })  : _getCurrentChapter = getCurrentChapter,
        super(ReaderInitial()) {
    on<ReaderEvent>(_emitLoading);
    on<ReaderNewChapter>(_onReaderNewChapter);
    on<ReaderNextChapter>(_onReaderNextChapter);
    on<ReaderPreviousChapter>(_onReaderPreviousChapter);
    on<ReaderShowAppBar>(_onReaderShowAppBar);
    on<ReaderChangeOrientation>(_onReaderChangeOrientation);
  }


  _onReaderChangeOrientation(
    ReaderChangeOrientation event,
    Emitter<ReaderState> emit,
  ) {
    if (state is! ReaderSuccess) return;
    emit(
      _readerS.copyWith(
        orientation: _readerS.orientation.next,
      ),
    );
  }

  Future<void> _onReaderNewChapter(
    ReaderNewChapter event,
    Emitter<ReaderState> emit,
  ) async {
    final res = await _getImagePageUrls(
      event: event,
      getCurrentChapter: _getCurrentChapter,
      hasReachedMaxOrMin: hasReachedMax || hasReachedMin,
    );
    return res.fold(
      (l) => _emitFailure(l, emit),
      (pages) => _emitSuccess(event, emit, pages),
    );
  }

  Future<void> _onReaderPreviousChapter(
    ReaderPreviousChapter event,
    Emitter<ReaderState> emit,
  ) async {
    final res = await _getImagePageUrls(
      event: event,
      getCurrentChapter: _getCurrentChapter,
      hasReachedMaxOrMin: hasReachedMax || hasReachedMin,
    );
    return res.fold(
      (l) => _emitFailure(l, emit),
      (pages) => _emitSuccess(event, emit, pages),
    );
  }

  Future<void> _onReaderNextChapter(
    ReaderNextChapter event,
    Emitter<ReaderState> emit,
  ) async {
    final res = await _getImagePageUrls(
      event: event,
      getCurrentChapter: _getCurrentChapter,
      hasReachedMaxOrMin: hasReachedMax || hasReachedMin,
    );
    return res.fold(
      (l) => _emitFailure(l, emit),
      (pages) => _emitSuccess(event, emit, pages),
    );
  }

  _emitSuccess(
    ReaderNewChapter event,
    Emitter<ReaderState> emit,
    List<String> pages,
  ) {
    if (state is! ReaderSuccess) {
      emit(
        ReaderSuccess(
          manga: event.manga,
          rawPages: {event.loadChapterIndex: pages},
          currentChapter: event.loadChapterIndex,
          isLoadingNewChapter: false,
        ),
      );
    } else {
      emit(
        _readerS.copyWith(
          manga: event.manga,
          rawPages: {
            ..._readerS.rawPages,
            ...{event.loadChapterIndex: pages}
          },
          currentChapter: event.loadChapterIndex,
          isLoadingNewChapter: false,
        ),
      );
    }
  }

  _emitFailure(Failure failure, Emitter<ReaderState> emit) {
    final state = this.state;
    emit(ReaderFailure(error: failure.message));
    emit(state);
  }

  _emitLoading(ReaderEvent event, Emitter<ReaderState> emit) {
    if (!isFirstLoad) {
      emit(
        _readerS.copyWith(
          isLoadingNewChapter: true,
        ),
      );
      return;
    }
    emit(ReaderLoading());
  }

  _onReaderShowAppBar(ReaderShowAppBar event, Emitter<ReaderState> emit) {
    if (state is! ReaderSuccess) return;
    event.showAppBar
        ? SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)
        : SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    emit(
      _readerS.copyWith(showAppBar: event.showAppBar),
    );
  }

  ReaderSuccess get _readerS => state as ReaderSuccess;
  bool get isFirstLoad => (state is! ReaderSuccess);
  bool get hasReachedMin => !isFirstLoad && !(_readerS.currentChapter - 1 >= 0);

  bool get hasReachedMax =>
      !isFirstLoad && !(_readerS.currentChapter + 1 < _readerS.manga.chapters.length);
}
