import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yomu_no_ikiru/constants.dart';
import 'package:yomu_no_ikiru/core/common/cubits/currentmanga/current_manga_cubit.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';
import 'package:yomu_no_ikiru/features/details/domain/usecase/get_manga_details.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final GetMangaDetails _getMangaDetails;
  final CurrentMangaCubit _currentMangaCubit;

  DetailsBloc({
    required GetMangaDetails getMangaDetails,
    required CurrentMangaCubit currentMangaCubit,
  })  : _getMangaDetails = getMangaDetails,
        _currentMangaCubit = currentMangaCubit,
        super(DetailsInitial()) {
    on<DetailsEvent>((_, emit) => DetailsLoading());
    on<DetailsFetch>(_onMangaFetchDetails, transformer: throttleRestartable(throttleDuration));
    on<DetailsAlreadyLoaded>((event, emit) => emit(DetailsSuccess(manga: event.manga)));
  }

  void _onMangaFetchDetails(DetailsFetch event, Emitter<DetailsState> emit) async {
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
      (l) => emit(DetailsFailure(error: l.message)),
      (manga) => _emitDetailsSuccess(manga, emit),
    );
  }

  _emitDetailsSuccess(Manga manga, Emitter<DetailsState> emit) {
    emit(DetailsSuccess(manga: manga));
    _currentMangaCubit.updateManga(manga);
  }
}
