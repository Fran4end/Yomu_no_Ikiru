part of 'explore_bloc.dart';

@immutable
sealed class ExploreEvent {
  const ExploreEvent();
}

final class ExploreFetchSearchList extends ExploreEvent {
  final String source;
  final int maxPagesize;
  final String query;
  final Map<String, dynamic> filters;

  const ExploreFetchSearchList({
    required this.maxPagesize,
    required this.source,
    required this.filters,
    this.query = "",
  });
}

final class ExploreResetList extends ExploreEvent {
  const ExploreResetList();
}
