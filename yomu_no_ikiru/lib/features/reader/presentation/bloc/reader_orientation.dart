import 'package:flutter/widgets.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/widgets/change%20page%20buttons/horizontal_change_buttons.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/widgets/change%20page%20buttons/vertical_change_buttons.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/widgets/orientation%20icons/occidental_horizontal_icon.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/widgets/orientation%20icons/oriental_horizontal_icon.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/widgets/orientation%20icons/vertical_icon.dart';

/// The reader orientation type
/// 
/// The type will be used to change the orientation of the reader state in rotation
enum ReaderOrientationType {
  occidentalHorizontal(
    axis: Axis.horizontal,
    reverse: false,
    icon: OccidentalHorizontalIcon(),
    changePageButtons: HorizontalChangeButtons(reverse: false),
  ),
  orientalHorizontal(
    axis: Axis.horizontal,
    reverse: true,
    icon: OrientalHorizontalIcon(),
    changePageButtons: HorizontalChangeButtons(),
  ),
  vertical(
    axis: Axis.vertical,
    reverse: false,
    icon: VerticalIcon(),
    changePageButtons: VerticalChangeButtons(),
  );

  final Axis axis;
  final bool reverse;
  final Widget icon;
  final Widget changePageButtons;

  const ReaderOrientationType({
    required this.axis,
    required this.reverse,
    required this.icon,
    required this.changePageButtons,
  });

  int get _currentIndex => ReaderOrientationType.values.indexOf(this);
  int get _nextIndex => (_currentIndex + 1) % ReaderOrientationType.values.length;
  ReaderOrientationType get next => ReaderOrientationType.values[_nextIndex];
}
