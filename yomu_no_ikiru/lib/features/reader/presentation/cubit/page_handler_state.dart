part of 'page_handler_cubit.dart';

/// State for [PageHandlerCubit]
/// 
/// [currentPage] is the current page of the manga.
/// [totalPages] is the total number of pages in the manga.
/// [isSliding] is true if the user is using the slider.
final class PageHandlerState extends Equatable {
  final int currentPage;
  final int totalPages;
  final bool isSliding;

  const PageHandlerState({
    required this.currentPage,
    required this.totalPages,
    this.isSliding = false,
  });

  factory PageHandlerState.initial() => const PageHandlerState(currentPage: 1, totalPages: 1);

  @override
  List<Object?> get props => [currentPage, totalPages, isSliding];

  PageHandlerState copyWith({
    int? currentPage,
    int? totalPages,
    bool? isSliding,
  }) {
    return PageHandlerState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isSliding: isSliding ?? this.isSliding,
    );
  }

  @override
  String toString() =>
      'PageHandlerState { currentPage: $currentPage, totalPages: $totalPages, isSliding: $isSliding }';
}
