import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'page_handler_state.dart';

class PageHandlerCubit extends Cubit<PageHandlerState> {
  PageHandlerCubit() : super(PageHandlerState.initial());

  /// Update the current page
  ///
  /// The method will update the current page that the user is currently reading.
  void updateCurrentPage(int newPage, [bool isSliding = false]) {
    if (_isSeparatorPage(newPage)) return;
    emit(state.copyWith(currentPage: newPage, isSliding: isSliding));
  }

  /// Reset the current page
  ///
  /// The method will reset the current page setting the state to the initial.
  void resetCurrentPage() {
    emit(PageHandlerState.initial());
  }

  /// Update the total pages
  ///
  /// The method will update the total pages of the current chapter immediately after the chapter is loaded.
  void updateTotalPages(int newTotalPages) {
    emit(state.copyWith(totalPages: newTotalPages));
  }

  /// Check if the current page is the first or the last page
  bool _isSeparatorPage(int index) => index == 0 || index == state.totalPages + 1;
}
