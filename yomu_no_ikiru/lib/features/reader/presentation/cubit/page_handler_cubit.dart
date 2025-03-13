import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'page_handler_state.dart';

class PageHandlerCubit extends Cubit<PageHandlerState> {
  PageHandlerCubit() : super(PageHandlerState.initial());

  void updateCurrentPage(int newPage, [bool isSliding = false]) {
    if (_isSeparatorPage(newPage)) return;
    print("updateCurrentPage: $newPage");
    emit(state.copyWith(currentPage: newPage, isSliding: isSliding));
  }

  void resetCurrentPage() {
    emit(PageHandlerState.initial());
  }

  void updateTotalPages(int newTotalPages) {
    emit(state.copyWith(totalPages: newTotalPages));
  }

  bool _isSeparatorPage(int index) => index == 0 || index == state.totalPages + 1;
}
