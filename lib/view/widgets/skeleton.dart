import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
    this.height,
    this.width,
    required this.color,
  });

  final double? height, width;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        //child: child,
      ),
    );
  }
}

class CardSkelton extends StatelessWidget {
  const CardSkelton({
    super.key,
    required this.aspectRatio,
  });

  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Card(
            elevation: 10,
            margin: const EdgeInsets.all(defaultPadding),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        Container(
          color: Colors.transparent,
          margin: const EdgeInsets.symmetric(horizontal: defaultPadding * 1.5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: const Skeleton(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SkeletonGrid extends StatelessWidget {
  const SkeletonGrid({
    super.key,
    this.axisCount = 2,
  });

  final int axisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: 10,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: axisCount,
        childAspectRatio: .9,
      ),
      itemBuilder: (context, index) => const CardSkelton(aspectRatio: .9),
    );
  }
}
