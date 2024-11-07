import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:yomu_no_ikiru/core/error/failures.dart';
import 'package:yomu_no_ikiru/features/manga/common/domain/entities/manga.dart';
import 'package:yomu_no_ikiru/features/manga/reader/domain/usecase/get_current_chapter.dart';

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
        (state as ReaderSuccess).copyWith(
          manga: event.manga,
          rawPages: {
            ...(state as ReaderSuccess).rawPages,
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
        (state as ReaderSuccess).copyWith(
          isLoadingNewChapter: true,
        ),
      );
      return;
    }
    emit(ReaderLoading());
  }

  _onReaderShowAppBar(ReaderShowAppBar event, Emitter<ReaderState> emit) {
    if (this.state is! ReaderSuccess) return;
    final state = this.state as ReaderSuccess;
    emit(
      state.copyWith(showAppBar: !state.showAppBar),
    );
  }

  bool get isFirstLoad => (state is ReaderInitial) || (state is ReaderLoading);
  bool get hasReachedMin => !isFirstLoad && !((state as ReaderSuccess).currentChapter - 1 >= 0);

  bool get hasReachedMax =>
      !isFirstLoad &&
      !((state as ReaderSuccess).currentChapter + 1 <
          (state as ReaderSuccess).manga.chapters.length);
}
