import 'package:flutter/widgets.dart';
import 'package:yomu_no_ikiru/features/manga/reader/presentation/widgets/occidental_horizontal_icon.dart';
import 'package:yomu_no_ikiru/features/manga/reader/presentation/widgets/oriental_horizontal_icon.dart';
import 'package:yomu_no_ikiru/features/manga/reader/presentation/widgets/vertical_icon.dart';

enum ReaderOrientationType {
  occidentalHorizontal(
    axis: Axis.horizontal,
    reverse: false,
    icon: OccidentalHorizontalIcon(),
  ),
  orientalHorizontal(
    axis: Axis.horizontal,
    reverse: true,
    icon: OrientalHorizontalIcon(),
  ),
  vertical(
    axis: Axis.vertical,
    reverse: false,
    icon: VerticalIcon(),
  );

  final Axis axis;
  final bool reverse;
  final Widget icon;

  const ReaderOrientationType({
    required this.axis,
    required this.reverse,
    required this.icon,
  });

  int get _currentIndex => ReaderOrientationType.values.indexOf(this);
  int get _nextIndex => (_currentIndex + 1) % ReaderOrientationType.values.length;
  ReaderOrientationType get next => ReaderOrientationType.values[_nextIndex];
}
