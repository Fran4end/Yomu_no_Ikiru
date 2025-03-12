part of 'details_bloc.dart';

@immutable
sealed class DetailsState {
  const DetailsState();
}

final class DetailsInitial extends DetailsState {}

final class DetailsLoading extends DetailsState {}

final class DetailsSuccess extends DetailsState {
  final Manga manga;

  const DetailsSuccess({required this.manga});
}

final class DetailsFailure extends DetailsState {
  final String error;

  const DetailsFailure({required this.error});
}
