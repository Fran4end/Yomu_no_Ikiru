import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:yomu_no_ikiru/core/common/entities/navigation_bar_destination.dart';

const double defaultPadding = 16;
final cacheOptions = CacheOptions(
  policy: CachePolicy.forceCache,
  store: MemCacheStore(),
  hitCacheOnErrorCodes: [401, 403],
  maxStale: const Duration(hours: 6),
  priority: CachePriority.high,
);

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration, [bool trailing = true]) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration, trailing: trailing), mapper);
  };
}

EventTransformer<E> throttleRestartable<E>(Duration duration, [bool trailing = true]) {
  return (events, mapper) {
    return restartable<E>().call(events.throttle(duration, trailing: trailing), mapper);
  };
}

EventTransformer<E> throttleSequential<E>(Duration duration, [bool trailing = true]) {
  return (events, mapper) {
    return sequential<E>().call(events.throttle(duration, trailing: trailing), mapper);
  };
}

EventTransformer<E> throttleConcurrent<E>(Duration duration, [bool trailing = true]) {
  return (events, mapper) {
    return concurrent<E>().call(events.throttle(duration, trailing: trailing), mapper);
  };
}

final List<NavigationBarDestination> navigationBarDestinations = [
  NavigationBarDestination(
    label: 'Explore',
    iconPath: 'assets/icons/explore.riv',
    routeName: '/explore',
    artboard: "EXPLORE",
    stateMachineName: "EXPLORE_Interactivity",
  ),
  NavigationBarDestination(
    label: 'Library',
    iconPath: 'assets/icons/library.riv',
    routeName: '/library',
    artboard: "LIBRARY",
    stateMachineName: "LIBRARY_Interactivity",
  ),
];
