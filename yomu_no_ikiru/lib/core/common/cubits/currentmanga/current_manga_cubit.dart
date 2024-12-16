import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yomu_no_ikiru/core/common/entities/manga/manga.dart';

part 'current_manga_state.dart';

class CurrentMangaCubit extends Cubit<CurrentMangaState> {
  CurrentMangaCubit() : super(CurrentMangaInitial());

  void updateManga(Manga? manga) {
    if (manga == null) {
      emit(CurrentMangaInitial());
    } else { 
      emit(CurrentMangaLoaded(manga));
    }
  }
}
