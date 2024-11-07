import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

const double defaultPadding = 16;
final cacheOptions = CacheOptions(
  policy: CachePolicy.forceCache,
  store: MemCacheStore(),
  hitCacheOnErrorExcept: [401, 403],
  maxStale: const Duration(hours: 6),
  priority: CachePriority.high,
);

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration, trailing: true), mapper);
  };
}

EventTransformer<E> throttleRestartable<E>(Duration duration) {
  return (events, mapper) {
    return restartable<E>().call(events.throttle(duration, trailing: true), mapper);
  };
}
